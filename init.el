(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(keyboard-translate ?\C-h ?\C-?)

(desktop-save-mode 1)

(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)

(global-set-key (kbd "C-S-h")  'windmove-left)
(global-set-key (kbd "C-S-l") 'windmove-right)
(global-set-key (kbd "C-S-k")    'windmove-up)
(global-set-key (kbd "C-S-j")  'windmove-down)

(setq load-prefer-newer t
      package-enable-at-startup nil
      package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-verbose t
      use-package-always-ensure t)

;; font setting
(create-fontset-from-ascii-font "Menlo-11:weight=normal:slant=normal" nil "menlomarugo")
(set-fontset-font "fontset-menlomarugo"
                  'unicode
                  (font-spec :family "Hiragino Maru Gothic ProN" :size 14)
                  nil
                  'append)
(add-to-list 'default-frame-alist '(font . "fontset-menlomarugo"))
(setq-default line-spacing 2)

(require 'package)
(setq color-themes '())
(use-package color-theme-solarized
  :config
  (when (memq window-system '(mac ns))
    (customize-set-variable 'frame-background-mode 'light)
    (load-theme 'solarized t)))

(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize)  
  )

(defun my/ido-recentf ()
  (interactive)
  (find-file (ido-completing-read "Find recent file: " recentf-list)))

(use-package recentf
  :config
  (setq recentf-max-saved-items 2000) ;; 2000ファイルまで履歴保存する
  (setq recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
  (setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)
  (bind-key "C-x C-r" 'my/ido-recentf)
  )


(use-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode 1))

(use-package ido-vertical-mode
  :config
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)
  (ido-vertical-mode 1))

(use-package smex
	     :config
	     (global-set-key (kbd "M-x") 'smex)
	     (global-set-key (kbd "M-X") 'smex-major-mode-commands))

(use-package elscreen
  :init
  (elscreen-start)
  :config
  ;; Key configs
  ;; (global-set-key (kbd "A-1") 'elscreen-previous)
  ;; (global-set-key (kbd "A-2") 'elscreen-next)
  ;; ;; Cloning is more useful than fresh creation
  ;; (global-set-key (kbd "A-c") 'elscreen-clone)
  ;; (global-set-key (kbd "A-k") 'elscreen-kill)
  ;; (global-set-key (kbd "A-r") 'elscreen-screen-nickname)
  ;;(global-set-key (kbd "C-; t") 'elscreen-toggle-display-tab)
  ;;(global-set-key (kbd "C-; l") 'helm-elscreen)
  ;;(global-set-key (kbd "C-; h") 'helm-elscreen)
)

(use-package auto-save-buffers-enhanced
  :config
  (setq auto-save-buffers-enhanced-interval 1)
  (setq auto-save-buffers-enhanced-include-regexps '(".+")) ;全ファイル
  (setq auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t)
  (setq auto-save-buffers-enhanced-file-related-with-scratch-buffer
	(locate-user-emacs-file "scratch"))
  (auto-save-buffers-enhanced t)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (custom-set-variables
   '(flycheck-disabled-checkers '(javascript-jshint javascript-jscs))
   )
  )

(use-package go-mode
  :config
  (setenv "GOPATH" (expand-file-name "~/go"))
  (bind-keys :map go-mode-map
	     ("M-." . godef-jump)
	     ("M-," . pop-tag-mark))
  (add-hook 'go-mode-hook '(lambda () (setq tab-width 2)))
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-eldoc
  :config 
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package rust-mode
  :config
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin/"))
  (setq-default rust-format-on-save t)
  (add-hook 'rust-mode-hook (lambda ()
			      (racer-mode)
			      (flycheck-rust-setup)))
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook (lambda ()
			       (company-mode)
                             ;;; この辺の設定はお好みで
			       (set (make-variable-buffer-local 'company-idle-delay) 0.1)
			       (set (make-variable-buffer-local 'company-minimum-prefix-length) 0)))
  )


(use-package popwin
  :config
  (popwin-mode 1))


(use-package rjsx-mode
  :config
  (add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode))
  (setq js2-strict-missing-semi-warning nil)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(frame-background-mode (quote light))
 '(package-selected-packages (quote (smex use-package color-theme-solarized))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
