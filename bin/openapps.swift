#!/usr/bin/env swift
import Cocoa

let apps = NSWorkspace.shared.runningApplications
for app in apps {
    if (app.activationPolicy == .regular) {
      print((app.localizedName ?? "Anonymous") + " (" + String(app.processIdentifier) + ")")
    }
}
