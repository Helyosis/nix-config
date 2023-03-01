;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Aloïs Colléaux-Le Chêne"
      user-mail-address "alois.colleaux-le-chene@epita.fr")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-material
      doom-font (font-spec :family "Comic Code Ligatures" :size 16 :weight 'medium))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Force emacs to use newer, non-compiled, packages to be up-to-date
(setq load-prefer-newer t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun get-base-dir (path)
  (file-name-nondirectory (directory-file-name (file-name-directory path)))
  )

;;(defun git-add-commit-tag-push ()
;;  (magit-stage-file)
;;  (magit-commit-create)
;;  (let tag (piscine-get-next-tag)
;;      (message tag)
;;       )
;;  )

(map!
 :leader
 :desc "Kill all GUD buffers"
 :n
 "d k" #'kill-all-gud-buffers
 )

(map! :after cc-mode
      :map c-mode-map
      :localleader
      :desc "Debug program"
      "d" (cmd! (gdb))
      )

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)


(defun force-kill-buffer (buffer)
  (setq kill-buffer-query-functions
        (delq 'process-kill-buffer-query-function kill-buffer-query-functions))
  (kill-buffer buffer)
  (add-to-list 'kill-buffer-query-functions 'process-kill-buffer-query-function))

(defvar all-gud-modes
  '(gud-mode comint-mode gdb-locals-mode gdb-frames-mode  gdb-breakpoints-mode)
  "A list of modes when using gdb")

(defun kill-all-gud-buffers ()
  "Kill all gud buffers including Debugger, Locals, Frames, Breakpoints.
Do this after `q` in Debugger buffer."
  (interactive)
  (save-excursion

    (let ((count 0))
      (dolist (buffer (buffer-list))
        (set-buffer buffer)
        (when (member major-mode all-gud-modes)
          (setq count (1+ count))
          (force-kill-buffer buffer)
          (delete-other-windows))) ;; fix the remaining two windows issue
      (message "Killed %i buffer(s)." count))))

;; Change the default file-templates for C headers
;; To use the coding-style allowed from school.
(set-file-template! ".+\\.h"
  :trigger "epita_header.h"
  :mode #'c-mode
  )

;; Set the default DAP python debugger to debugpy
;; Because it is the one recommended in Doom Emacs documentation
(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(defun my/debug ()
  (interactive)
  (dap-debug
   (list :type "gdb"
         :request "launch"
         :name "my/debug"
         :MIMode "gdb"
         :program (read-file-name "Enter the binary to debug..." (projectile-project-root))
         :cwd (projectile-project-root)
         :environment [])))

;; Load private package to use flex-mode
;; Also, as I don't use Lisp but flex, .l file are Flex files and not lisp
(load! "lisp/flex.el")
(load! "lisp/bison-mode.el")
(add-to-list 'auto-mode-alist '("\\.l\\'" . flex-mode))
(add-to-list 'auto-mode-alist '("\\.y\\'" . bison-mode))

;; Specify the mermaid executable
(setq ob-mermaid-cli-path "~/.npm-global/bin/mmdc")

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (mermaid . t)
   (scheme . t)
   ))

;; (set-frame-parameter nil 'alpha-background 80)
;; (pixel-scroll-precision-mode t)

(global-auto-revert-mode t)


(add-to-list 'auto-mode-alist '("\\meson.build\'" . meson-mode))

(use-package! kbd-mode
        :custom
        (kbd-mode-kill-kmonad "pkill -9 kmonad")
        (kbd-mode-start-kmonad "kmonad ~/.config/kmonad/config.kbd")
  )
