;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

;;; Commentary:
;; Emacs 27+ early initialization file.
;; Runs before init.el for performance optimizations.

;;; Code:

;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent package.el from loading packages before init.el
(setq package-enable-at-startup nil)

;; Disable UI elements early for faster startup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent flash of unstyled content
(setq frame-inhibit-implied-resize t)

;;; early-init.el ends here
