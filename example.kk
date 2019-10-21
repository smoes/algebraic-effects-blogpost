module example

// exception example

effect exception {
  fun raise(msg : string) : a
}

fun custom-catch(try-fun, catch-fun)  {
  handle(try-fun) {
    raise(msg) -> catch-fun(msg)
  }
}


// divsion with exceptions

fun div(a : int, b: int) : <exception> int {
  if(b == 0) then raise("Division by Zero")
  else a / b
}

fun safediv(a : int, b: int) : int {
  custom-catch({div(a,b)}, fun(_msg){0})
}



// User-repository example

struct user (id: int, name: string)


effect user-repository {
  fun add-user(name : string) : int
  fun get-user(id : int) : user
}

fun add-user-with-name(firstname: string, lastname: string): <user-repository, exception> int {
  if(firstname.vector.length == 0 || lastname.vector.length == 0) then
    raise("first- or lastname empty")
  else
    add-user(firstname + " " + lastname)
}

fun get-user-name(id : int) : <user-repository> string {
  val user = get-user(id)
  user.name
}



// "mysql"-Implementation of the handler
// Just as an example, can be anything

fun mysql-add-user(user-name) {
   1  // would return id, we implement it for compiler
}

fun mysql-get-user(id : int) : user {
   User(1, "Bob Booobig")
}


val database-handler = handler {
  return x -> x
  add-user(user-name) ->
     resume( mysql-add-user(user-name) )
  get-user(id) ->
     resume( mysql-get-user(id) )
}


// main 

public fun main() : <console> () {

  println(
      custom-catch({ 
        database-handler({add-user-with-name("Bob", "Bobbig")})
      }, fun(msg){ -1 })
  )
  // number division
  println("We are just dividing numbers! Or, aren't we?")
  println(safediv(6,0))


  // user-repo
}