//
//  Exports.swift
//  MessageStackView
//
//  Copyright © 2026 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

// Re-export the ObjC target (Reachability, swizzling helpers) so SPM
// consumers only need `import MessageStackView`. In the framework and
// CocoaPods builds the ObjC sources live in this module, so no-op.
#if canImport(MessageStackViewObjC)
@_exported import MessageStackViewObjC
#endif
