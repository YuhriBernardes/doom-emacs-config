;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yuhri Bernardes"
      user-mail-address "yuhri.graziano@gmail.com")

(doom/set-indent-width 2)

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

(setq doom-font (font-spec :family "Source Code Pro" :size 14 :weight 'normal))
;; (setq doom-big-font (font-spec :family "Source Code Pro" :size 18 :weight 'normal))
(setq doom-big-font (font-spec :family "Source Code Pro" :size 23 :weight 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(defun random-theme (theme-list)
  (setq doom-theme (seq-random-elt theme-list))
  (doom/reload-theme))

(defun random-dark-theme ()
  (interactive)
  (random-theme '(doom-moonlight doom-laserwave doom-challenger-deep doom-city-lights)))

(defun random-light-theme ()
  (interactive)
  (random-theme '(doom-one-light doom-acario-light doom-nord-light doom-solarized-light doom-tomorrow-day)))

(random-dark-theme)
;; (random-light-theme)


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
;;;;;;;;;;;;;;

(use-package! plantuml-mode
  :config
  (setq plantuml-default-exec-mode 'jar))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Docker compose mode ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'docker-compose-mode)

;;;;;;;;;
;; RGB ;;
;;;;;;;;;

(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

;;;;;;;;;;;
;; Kubel ;;
;;;;;;;;;;;

(use-package! kubel
  :config
  (map! :leader (:desc "Kubel" "o k" #'kubel))
  (map! :mode kubel-mode :n "q" #'with-editor-finish)
  (map!
   :mode kubel-mode
   :leader
   :localleader
   (:desc "resource-details" "RET" #'kubel-get-resource-details
    :desc "set-context" "c" #'kubel-set-context
    :desc "set-namespace" "n" #'kubel-set-namespace
    :desc "kubel-mode" "g" #'kubel-mode
    :desc "port-foward-pod" "p" #'kubel-port-forward-pod
    :desc "log-popup" "l" #'kubel-log-popup
    :desc "copy-popup" "C" #'kubel-copy-popup
    :desc "kubel-help" "?" #'kubel-evil-help-popup
    :desc "quicl-edit" "E" #'kubel-quick-edit
    :desc "exec-pod" "e" #'kubel-exec-pod
    :desc "set-output-format" "f" #'kubel-set-output-format
    :desc "delete-popup" "d" #'kubel-delete-popup
    :desc "set-resource" "r" #'kubel-set-resource
    :desc "jab-deployment" "a" #'kubel-jab-deployment)))

;;;;;;;;;;;
;; Cider ;;
;;;;;;;;;;;

(defun cider-eval-last-sexp-to-clipboard (&optional pretty-print)
 (interactive "P")
 (cider-interactive-eval nil
                         (nrepl-make-response-handler nil
                                                      (lambda (_buffer value)
                                                        (kill-new value)
                                                        (message "copied %s" value))
                                                      (lambda (_buffer out)
                                                        (kill-new out)
                                                        (message "copied %s" out))
                                                      (lambda (_ err)
                                                        (message "error evaluating: %s" err))
                                                      '())
                         (cider-last-sexp 'bounds)
                         (if pretty-print
                              (cider--nrepl-print-request-map fill-column)
                            (cider--nrepl-pr-request-map))))

(map!
 :i "TAB" #'company-complete
 (:localleader
  (:map (clojure-mode-map clojurescript-mode-map)
   (:prefix ("l" . "load")
    "a" #'cider-load-all-files
    "f" #'cider-load-file)
   (:prefix ("e" . "eval")
    "p" #'cider-pprint-eval-last-sexp
    "n" #'cider-eval-ns-form
    "w" #'cider-eval-last-sexp-and-replace
    "c" #'cider-eval-last-sexp-to-clipboard))))

(map!
 :i "TAB" #'+company/complete
 :v  "U" #'undo-tree-visualize)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit | Gist | Forge ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq auth-sources '("~/.authinfo"))

(map!
 (:leader
  "g k" #'with-editor-cancel
  "g f" #'with-editor-finish))

;;;;;;;;;;;;;;;;;;
;; Smart Parens ;;
;;;;;;;;;;;;;;;;;;
(map!
 :leader
 (:desc "wrap-square" "[ [" #'sp-wrap-square
  :desc "wrap-curly" "[ {" #'sp-wrap-curly
  :desc "wrap-parens" "[ (" #'sp-wrap-round
  :desc "slurp-foward" "[ l" #'sp-forward-slurp-sexp
  :desc "barf-foward" "[ h" #'sp-forward-barf-sexp
  :desc "slurp-backward" "] l" #'sp-backward-slurp-sexp
  :desc "barf-backward" "] h" #'sp-backward-barf-sexp
  :desc "splice-sexp" "[ s" #'sp-splice-sexp))


;;;;;;;;;;;;;;;;
;; Projectile ;;
;;;;;;;;;;;;;;;;

(after! projectile
  (setq projectile-project-root-files
        (append projectile-project-root-files-bottom-up
                (add-to-list 'projectile-project-root-files "go.mod"))
        projectile-project-root-files-bottom-up nil))

;;;;;;;;
;; Go ;;
;;;;;;;;

(defun go-format-custom-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")

  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save))

(add-hook 'go-mode-hook 'go-format-custom-hook)

;; Run this if you need to use build tags. After that, restart lsp workspace
;; (setq lsp-go-env (make-hash-table))
;; (puthash "GOFLAGS" "-tags=test" lsp-go-env)

;;;;;;;;;;;
;; Other ;;
;;;;;;;;;;;

;; Smartparens force strict mode
(setq smartparens-global-strict-mode t)

(use-package! treemacs
  :config
  (treemacs-git-mode 'extended)
  (setq treemacs-project-follow-cleanup t)
  (setq treemacs-missing-project-action 'remove))

;; (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
;; (map! "TAB" #'company-indent-or-complete-common)

(map! :leader
      :desc "Maximize window" "w m m" #'maximize-window
      :desc "Minimize window" "w m n" #'minimize-window
      :desc "ace-window" "w a" #'ace-window
      :desc "ace-delete-wintow" "w D" #'ace-delete-window
      :desc "line-toggle-comment" "c l" #'evilnc-comment-or-uncomment-lines)

(toggle-frame-fullscreen)

;;;;;;;;;;;;;;
;; Snippets ;;
;;;;;;;;;;;;;;

(setq yas-indent-line 'auto)
