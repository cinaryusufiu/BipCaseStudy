//
//  TypeAliases.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

typealias Completion = () -> Void
typealias CompletionBool = (Bool) -> Void
typealias CompletionInt = (Int) -> Void
typealias CompletionString = (String) -> Void
typealias CompletionHandler<T> = (T) -> Void
typealias Predicate<T> = (T) -> Bool
