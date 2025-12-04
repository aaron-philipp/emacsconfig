;;; init.el --- Emacs Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration with use-package

;;; Code:

;; ============================================================================
;; Package Management
;; ============================================================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Reset GC threshold after startup (set high in early-init.el)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; Auto-update packages (defer - not needed at startup)
(use-package auto-package-update
  :defer t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t))

;; ============================================================================
;; General Settings
;; ============================================================================

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Disable toolbar
(tool-bar-mode -1)

;; Disable menu bar (optional - uncomment if desired)
;; (menu-bar-mode -1)

;; Disable scroll bar (optional - uncomment if desired)
;; (scroll-bar-mode -1)

;; Set frame transparency
(set-frame-parameter nil 'alpha '(99))
(add-to-list 'default-frame-alist '(alpha . (99)))

;; Set initial frame size (columns x rows)
(set-frame-size (selected-frame) 100 50)

;; Line numbers
(global-display-line-numbers-mode t)

;; Highlight current line
(global-hl-line-mode t)

;; Show matching parentheses
(show-paren-mode t)

;; Auto-revert buffers when files change on disk
(global-auto-revert-mode t)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; UTF-8 everywhere
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Font size
(set-face-attribute 'default nil :height 120)

;; Emoji font fallback (Windows: Segoe UI Emoji, macOS: Apple Color Emoji)
(when (display-graphic-p)
  (set-fontset-font t 'emoji
                    (cond
                     ((eq system-type 'windows-nt) "Segoe UI Emoji")
                     ((eq system-type 'darwin) "Apple Color Emoji")
                     (t "Noto Color Emoji"))
                    nil 'prepend))

;; ============================================================================
;; Theme
;; ============================================================================

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

;; ============================================================================
;; Icons (nerd-icons - better maintained than all-the-icons)
;; ============================================================================

;; Run M-x nerd-icons-install-fonts on first use
(use-package nerd-icons
  :if (display-graphic-p))

(use-package nerd-icons-dired
  :after nerd-icons
  :hook (dired-mode . nerd-icons-dired-mode))

;; ============================================================================
;; Dashboard
;; ============================================================================

(use-package dashboard
  :after nerd-icons
  :config
  (setq dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory))
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "Take Dead Aim")
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-footer nil)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 5)
                          (agenda . 5)
                          (projects . 5)))
  ;; Navigator buttons
  (setq dashboard-navigator-buttons
        `(((,(nerd-icons-faicon "nf-fa-github" :height 1.0 :v-adjust 0.0)
            "Repos" "GitHub Repos"
            (lambda (&rest _) (browse-url "https://github.com/")))
           (,(nerd-icons-faicon "nf-fa-building" :height 1.0 :v-adjust 0.0)
            "Jira" "Atlassian"
            (lambda (&rest _) (browse-url "https://start.atlassian.com/")))
           (,(nerd-icons-faicon "nf-fa-envelope" :height 1.0 :v-adjust 0.0)
            "Gmail" "Email"
            (lambda (&rest _) (browse-url "https://mail.google.com/"))))))
  (dashboard-setup-startup-hook))

;; ============================================================================
;; Project Management
;; ============================================================================

(use-package projectile
  :diminish projectile-mode
  :defer 0.5
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; ============================================================================
;; Navigation & Search (ivy/counsel/swiper)
;; ============================================================================

(use-package ivy
  :diminish ivy-mode
  :defer 0.1
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  :after ivy
  :diminish counsel-mode
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . ivy-switch-buffer)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep))
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-backward)))

(use-package neotree
  :commands neotree-toggle
  :bind ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; ============================================================================
;; Autocompletion
;; ============================================================================

(use-package company
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t))

;; ============================================================================
;; Programming - General
;; ============================================================================

(use-package flycheck
  :defer 1
  :config (global-flycheck-mode))

(use-package rainbow-identifiers
  :hook (prog-mode . rainbow-identifiers-mode))

(use-package origami
  :hook (prog-mode . origami-mode))

;; ============================================================================
;; Programming - Python
;; ============================================================================

(use-package elpy
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

(use-package anaconda-mode
  :hook ((python-mode . anaconda-mode)
         (python-mode . anaconda-eldoc-mode)))

;; ============================================================================
;; Programming - Web
;; ============================================================================

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.tsx?\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package npm-mode
  :hook (web-mode . npm-mode))

(use-package web-beautify
  :defer t)

;; ============================================================================
;; LSP (Language Server Protocol)
;; ============================================================================

(use-package lsp-mode
  :hook ((python-mode . lsp-deferred)
         (web-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-sideline-enable t))

;; ============================================================================
;; Org Mode
;; ============================================================================

(use-package org
  :defer t
  :config
  (setq org-startup-indented t)
  (setq org-hide-leading-stars t))

(use-package org-timeline
  :hook (org-agenda-finalize . org-timeline-insert-timeline))

;; ============================================================================
;; Modeline
;; ============================================================================

(use-package spaceline
  :defer 0.5
  :config
  (spaceline-emacs-theme))

(use-package mode-icons
  :defer 0.5
  :config
  (mode-icons-mode))

;; ============================================================================
;; AI - Claude Code (via agent-shell + ACP)
;; ============================================================================

;; Requires:
;;   npm install -g @anthropic-ai/claude-code
;;   npm install -g @zed-industries/claude-code-acp

(use-package agent-shell
  :vc (:url "https://github.com/xenodium/agent-shell" :rev :newest)
  :bind (("C-c c c" . agent-shell)
         ("C-c c n" . agent-shell-new))
  :config
  (setq agent-shell-default-agent "claude-code-acp"))

;; ============================================================================
;; Fun Stuff
;; ============================================================================

(use-package emojify
  :defer 2
  :config (global-emojify-mode))

(use-package chess
  :defer t)

;; ============================================================================
;; Custom File
;; ============================================================================

;; Keep customize settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
