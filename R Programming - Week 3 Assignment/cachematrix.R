## As the Matrix inversion is usually a costly computation, we want to cache 
## all the computations that are made so that we are not computing it repeatedly.
## An example of the flow while using this functions is:
## - First: pass the matrix to makeCacheMatrix and assign the returned list 
##          to a symbol
## - Second: calculate the Inverse passing the the previous symbol/list 
##           to cacheSolve
## - Third: you can assign the calculated Inverse to a symbol or simply print it.


## makeCacheMatrix() caches potentially time-consuming computations when
## solving the Inverse of a matrix.
## Creates an object that is a list containing the matrix, the Inverse and the 
## following functions:
## - 'set' sets matrix and invalidates cache
## - 'get' returns the matrix
## - 'setinv' saves the Inverse (the value of the solve() function)
## - 'getinv' returns the saved Inverse


makeCacheMatrix <- function(x = matrix()) {
  i <- NULL
  set <- function(y) {
    x <<- y
    i <<- NULL ## matrix changed, invalidate cache
  }
  get <- function() x
  setinv <- function(inv) i <<- inv
  getinv <- function() i
  list(set = set, get = get,
       setinv = setinv,
       getinv = getinv)
}


## cacheSolve() calculates the Inverse of the matrix contained in the object
## created with makeCacheMatrix(). However, it first checks to see if the 
## Inverse has already been calculated. If so, it retrieves the Inverse from the 
## cache and skips the computation. Otherwise, it calculates the Inverse of the 
## matrix and sets the value of the Inverse in the cache via the setinv function.


cacheSolve <- function(x, ...) {
  i <- x$getinv()
  
  ## if inverse is cached then nothing to compute
  if(!is.null(i)) {
    message("getting cached data")
    return(i)
  }
  
  ## compute inverse and save in cache
  i <- solve(x$get(), ...)
  x$setinv(i)
  i
}
