//
//  CustomFactorial.swift
//  SwiftPractice
//
//  Created by HenryFan on 27/6/2018.
//  Copyright © 2018 HenryFanDi. All rights reserved.
//

import Foundation

public class CustomFactorial {
    // Set both customDecrement and randomDecrement as internal and mark them as @usableFromInline since you use them in the inlined factorial implementation
    @usableFromInline let customDecrement: Bool
    
    public init(_ customDecrement: Bool = false) {
        self.customDecrement = customDecrement
    }
    
    @usableFromInline var randomDecrement: Int {
        return Bool.random() ? 2 : 3
    }
    
    // Annotate factorial(_:) with @inlinable to make it inline. This is possible because you declared the function as public.
    @inlinable public func factorial(_ n: Int) -> Int {
        guard n > 1 else {
            return 1
        }
        let decrement = customDecrement ? randomDecrement : 1
        return n * factorial(n - decrement)
    }
}
