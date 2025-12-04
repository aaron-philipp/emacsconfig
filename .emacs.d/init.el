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

;; Auto-update packages
(use-package auto-package-update
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

;; Set initial frame size
(set-frame-size (selected-frame) 80 40)

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

;; ============================================================================
;; Theme
;; ============================================================================

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

;; ============================================================================
;; Icons
;; ============================================================================

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

;; ============================================================================
;; Dashboard
;; ============================================================================

(use-package dashboard
  :after all-the-icons
  :config
  (setq dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory))
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "Take Dead Aim")
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-footer nil)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 5)
                          (agenda . 5)
                          (projects . 5)))
  ;; Navigator buttons
  (setq dashboard-navigator-buttons
        `(((,(all-the-icons-octicon "mark-github" :height 1.0 :v-adjust 0.0)
            "Repos" "GitHub Repos"
            (lambda (&rest _) (browse-url "https://github.com/")))
           (,(all-the-icons-octicon "organization" :height 1.0 :v-adjust 0.0)
            "Jira" "Atlassian"
            (lambda (&rest _) (browse-url "https://start.atlassian.com/")))
           (,(all-the-icons-octicon "mail-read" :height 1.0 :v-adjust 0.0)
            "Gmail" "Email"
            (lambda (&rest _) (browse-url "https://mail.google.com/"))))))
  (dashboard-setup-startup-hook))

;; ============================================================================
;; Project Management
;; ============================================================================

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; ============================================================================
;; Navigation & Search (ivy/counsel/swiper)
;; ============================================================================

(use-package ivy
  :diminish ivy-mode
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
  :init (global-flycheck-mode))

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

(use-package web-beautify)

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
  :config
  (setq org-startup-indented t)
  (setq org-hide-leading-stars t))

(use-package org-timeline
  :hook (org-agenda-finalize . org-timeline-insert-timeline))

;; ============================================================================
;; Modeline
;; ============================================================================

(use-package spaceline
  :config
  (spaceline-emacs-theme))

(use-package mode-icons
  :config
  (mode-icons-mode))

;; ============================================================================
;; AI - Claude Code
;; ============================================================================

;; Terminal emulator for Claude Code (using eat - lighter than vterm)
(use-package eat
  :ensure t)

;; Claude Code integration
;; Requires: npm install -g @anthropic-ai/claude-code
;; Or: brew install anthropic/tap/claude-code
(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :after eat
  :config
  ;; Use eat as the terminal backend (alternative: 'vterm)
  (setq claude-code-terminal-backend 'eat)
  ;; Enable global mode for keybindings
  (claude-code-mode 1)
  :bind-keymap
  ("C-c c" . claude-code-command-map))

;; Optional: Monet for go-to-definition from Claude suggestions
;; (use-package monet
;;   :vc (:url "https://github.com/stevemolitor/monet" :rev :newest)
;;   :config
;;   (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
;;   (monet-mode 1))

;; Claude Code Keybindings (with C-c c prefix):
;;   C-c c c   - Start Claude Code in project root
;;   C-c c s   - Send prompt to Claude
;;   C-c c x   - Send prompt with current file context
;;   C-c c e   - Fix error at point (flycheck/flymake)
;;   C-c c r   - Resume previous session
;;   C-c c k   - Kill Claude process
;;   C-c c m   - Cycle mode (default/auto-accept/plan)

;; ============================================================================
;; Fun Stuff
;; ============================================================================

(use-package emojify
  :hook (after-init . global-emojify-mode))

(use-package chess)

;; ============================================================================
;; Custom File
;; ============================================================================

;; Keep customize settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
