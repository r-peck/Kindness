// Copyright © 2018 the Kindness project contributors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

infix operator •: InfixR9
infix operator >>>: InfixR9
infix operator <<<: InfixR9

/// Compose two functions to make a single function: "g after f"
///
/// - Parameters:
///   - g: Function to perform second
///   - f: Function to perform first
/// - Returns: Function from input of `f` to output of `g` that calls "g after f"
public func • <A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> C {
    return { g(f($0)) }
}

/// Backward composition. Compose two functions to make a single function: "g after f"
///
/// - Parameters:
///   - g: Function to perform second
///   - f: Function to perform first
/// - Returns: Function from input of `f` to output of `g` that calls "g after f"
public func <<< <A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> C {
    return { g(f($0)) }
}

/// Forward composition. Compose two functions to make a single function: "f before g"
///
/// - Parameters:
///   - f: Function to perform first
///   - g: Function to perform second
/// - Returns: Function from input of `f` to output of `g` that calls "f before g"
public func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

infix operator |>: InfixL1

/// Applies the argument on the left to the function on the right
///
/// - Parameters:
///   - a: Argument to apply
///   - f: Function to call
/// - Returns: Result of calling `f` with `a`
public func |> <A, B> (_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

/// Applies the argument on the left to the function on the right
///
/// - Parameters:
///   - a: Argument to apply
///   - f: Function to call
/// - Returns: Result of calling `f` with `a`
public func |> <A, B, C> (_ a: A, _ f: @escaping (A, B) -> C) -> (B) -> C {
    return { b in f(a, b) }
}

/// Applies the argument on the left to the function on the right
///
/// - Parameters:
///   - a: Argument to apply
///   - f: Function to call
/// - Returns: Result of calling `f` with `a`
public func |> <A, B, C, D> (_ a: A, _ f: @escaping (A, B, C) -> D) -> (B, C) -> D {
    return { b, c in f(a, b, c) }
}

/// Applies the argument on the left to the function on the right
///
/// - Parameters:
///   - a: Argument to apply
///   - f: Function to call
/// - Returns: Result of calling `f` with `a`
public func |> <A, B, C, D, E> (_ a: A, _ f: @escaping (A, B, C, D) -> E) -> (B, C, D) -> E {
    return { b, c, d in f(a, b, c, d) }
}

infix operator <|: InfixR0

/// Applies the argument on the right to the function on the left
///
/// - Parameters:
///   - f: Function to call
///   - a: Argument to apply
/// - Returns: Result of calling `f` with `a`
public func <| <A, B> (_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

/// Applies the argument on the right to the function on the left
///
/// - Parameters:
///   - f: Function to call
///   - a: Argument to apply
/// - Returns: Result of calling `f` with `a`
public func <| <A, B, C> (_ f: @escaping (A, B) -> C, _ a: A) -> (B) -> C {
    return { b in f(a, b) }
}

/// Applies the argument on the right to the function on the left
///
/// - Parameters:
///   - f: Function to call
///   - a: Argument to apply
/// - Returns: Result of calling `f` with `a`
public func <| <A, B, C, D> (_ f: @escaping (A, B, C) -> D, _ a: A) -> (B, C) -> D {
    return { b, c in f(a, b, c) }
}

/// Applies the argument on the right to the function on the left
///
/// - Parameters:
///   - f: Function to call
///   - a: Argument to apply
/// - Returns: Result of calling `f` with `a`
public func <| <A, B, C, D, E> (_ f: @escaping (A, B, C, D) -> E, _ a: A) -> (B, C, D) -> E {
    return { b, c, d in f(a, b, c, d) }
}

/// Returns the value passed in unchanged
///
/// - Parameter a: a value
/// - Returns: The same value `a`
public func id<A>(_ a: A) -> A {
    return a
}

/// Given a value `b`, return a function that ignores its input and always returns `b`.
///
/// - Parameter b: Value the resulting function should always return
/// - Returns: A function that always returns `b`
public func const<A, B>(_ b: B) -> (A) -> B {
    return { _ in b }
}

/// Given a function that takes a pair `(A, B)` and returns `C`, return a function that takes `A`, then returns a
/// function `(B) -> C`.
///
/// - Parameter f: Function from pair (A, B) -> C
/// - Returns: Curried function (A) -> (B) -> C
public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

/// Given a function that takes `A `and returns a function `(B) -> C`, returns a function `(A, B) -> C`.
///
/// - Parameter f: Curried function `(A) -> (B) -> C`
/// - Returns: Uncurried function `(A, B) -> C`
public func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
    return { a, b in f(a)(b) }
}

/// Flip the order of arguments in a curried function
///
/// - Parameter f: Function in which the argument order should be flipped
/// - Returns: Function with the order of the first two arguments flipped
public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

/// Flip the order of arguments in an uncurried function
///
/// - Parameter f: Function in which the argument order should be flipped
/// - Returns: Function with the order of the two arguments flipped
public func flip<A, B, C>(_ f: @escaping (A, B) -> C) -> (B, A) -> C {
    return { b, a in f(a, b) }
}
