;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yuhri Bernardes"
      user-mail-address "yuhri.graziano@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "Iosevka" :size 14 :weight 'normal))
(setq doom-big-font (font-spec :family "Iosevka" :size 19 :weight 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-moonlight)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;
;; PlantUML ;;
;;;;;;;;;;;;;;

(use-package! plantuml-mode
  :config
  (setq plantuml-jar-path "/lib/plantuml/plantuml.jar")
  (setq org-plantuml-jar-path "/lib/plantuml/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
;;;###autoload
  (with-eval-after-load "org"
      (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))))

;; Smartparens force strict mode
(setq smartparens-global-strict-mode 1)

(require 'treemacs)
(treemacs-git-mode 'extended)

(map!
 :after clojure-mode
 :map (clojure-mode-map cider-mode-map cider-repl-mode-map)
 :leader
 (:desc "wrap-square" "[ [" #'sp-wrap-square
  :desc "wrap-curly" "[ {" #'sp-wrap-curly
  :desc "wrap-parens" "[ (" #'sp-wrap-round
  :desc "slurp-foward" "[ l" #'sp-forward-slurp-sexp
  :desc "barf-foward" "[ h" #'sp-forward-barf-sexp
  :desc "slurp-backward" "] l" #'sp-backward-slurp-sexp
  :desc "barf-backward" "] h" #'sp-backward-barf-sexp
  :desc "splice-sexp" "[ s" #'sp-splice-sexp
  :desc "pprint-result" "m e p" #'cider-pprint-eval-last-sexp
  :desc "eval-ns-form" "m e n" #'cider-eval-ns-form)
 :desc "add-doublequote" "\"" #'paredit-doublequote)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(map! "TAB" #'company-indent-or-complete-common)

(map! :leader
      :desc "Maximize window" "w m m" #'maximize-window
      :desc "Minimize window" "w m n" #'minimize-window
      :desc "ace-window" "w a" #'ace-window
      :desc "ace-delete-wintow" "w D" #'ace-delete-window
      :desc "line-toggle-comment" "c l" #'evilnc-comment-or-uncomment-lines)

(map!
 :map with-editor-mode-map
 :leader
 :desc "With editor finish" "m k" #'with-editor-cancel
 :desc "With editor finish" "m f" #'with-editor-finish)
