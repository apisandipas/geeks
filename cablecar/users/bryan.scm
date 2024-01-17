(define-module (rde-configs users abcdw)
  #:use-module (contrib features javascript)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services xdg)
  #:use-module (gnu services desktop)
  #:use-module (gnu services sddm)
  #:use-module (gnu home services)
  #:use-module (gnu home-services ssh)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix channels)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix inferior)
  #:use-module (guix packages)
  #:use-module (rde features base)
  #:use-module (rde features wm)
  #:use-module (rde features clojure)
  #:use-module (rde features emacs-xyz)
  #:use-module (rde features gnupg)
  #:use-module (rde features irc)
  #:use-module (rde features keyboard)
  #:use-module (rde features mail)
  #:use-module (rde features networking)
  #:use-module (rde features password-utils)
  #:use-module (rde features security-token)
  #:use-module (rde features system)
  #:use-module (rde features xdg)
  #:use-module (rde features markup)
  #:use-module (rde features docker)
  #:use-module (rde features virtualization)
  #:use-module (rde features ocaml)
  #:use-module (rde features presets)
  #:use-module (rde features version-control)
  #:use-module (rde features video)
  #:use-module (rde features)
  #:use-module (rde home services emacs)
  #:use-module (rde home services i2p)
  #:use-module (rde home services wm)
  #:use-module (rde home services video)
  #:use-module (rde packages aspell)
  #:use-module (rde packages)
  #:use-module (srfi srfi-1))

;;; Helpers

(define* (mail-acc id user #:optional (type 'gmail))
  "Make a simple mail-account with gmail type by default."
  (mail-account
   (id   id)
   (fqda user)
   (type type)))

(define* (mail-lst id fqda urls)
  "Make a simple mailing-list."
  (mailing-list
   (id   id)
   (fqda fqda)
   (config (l2md-repo
            (name (symbol->string id))
            (urls urls)))))

;;; Service extensions

(define emacs-extra-packages-service
  (simple-service
   'emacs-extra-packages
   home-emacs-service-type
   (home-emacs-extension
    (init-el
     `((with-eval-after-load 'org
         (setq org-use-speed-commands t)
         (define-key org-mode-map (kbd "M-o")
           (lambda ()
             (interactive)
             (org-end-of-meta-data t))))
       (with-eval-after-load 'geiser-mode
         (setq geiser-mode-auto-p nil)
         (defun abcdw-geiser-connect ()
           (interactive)
           (geiser-connect 'guile "localhost" "37146"))

         (define-key geiser-mode-map (kbd "C-c M-j") 'abcdw-geiser-connect))
       (with-eval-after-load 'simple
         (setq-default display-fill-column-indicator-column 80)
         (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))
       (setq copyright-names-regexp
             (format "%s <%s>" user-full-name user-mail-address))
       (add-hook 'after-save-hook (lambda () (copyright-update nil nil)))))
    (elisp-packages
     (append
      (list
       ;; (@ (rde packages emacs-xyz) emacs-corfu-candidate-overlay)
       )
      (strings->packages
       ;; "emacs-dirvish"
       "emacs-company-posframe"
       "emacs-eat"
       "emacs-wgrep"
       "emacs-piem"
       "emacs-geiser"
       "emacs-ox-haunt"
       "emacs-org-wild-notifier"
       "emacs-haskell-mode"
       "emacs-rainbow-mode"
       "emacs-hl-todo"
       "emacs-yasnippet"
       ;; "emacs-consult-dir"
       "emacs-kind-icon"
       "emacs-nginx-mode" "emacs-yaml-mode"
       "emacs-arei"
       "emacs-ytdl"
       "emacs-multitran"
       "emacs-minimap"
       "emacs-ement"
       "emacs-restart-emacs"
       "emacs-org-present"))))))

(define home-extra-packages-service
  (simple-service
   'home-profile-extra-packages
   home-profile-service-type
   (append
    (list
     (@ (gnu packages tree-sitter) tree-sitter-clojure)
     (@ (gnu packages tree-sitter) tree-sitter-html)
     (@ (gnu packages guile) guile-next))
    (strings->packages
     "figlet" ;; TODO: Move to emacs-artist-mode
     "calibre"
     "firefox" "nyxt"
     "hut"
     "utox" "qtox"
     "alsa-utils" "yt-dlp" "cozy"
     "pavucontrol" "wev"
     "imagemagick"
     "obs" "obs-wlrobs"
     "recutils" "binutils" "make" "gdb"
     "fheroes2"
     "hicolor-icon-theme" "adwaita-icon-theme" "gnome-themes-extra"
     "arc-theme"
     "thunar" "fd"
     "libreoffice"
     "ffmpeg"
     "ripgrep" "curl"))))

(define (wallpaper url hash)
  (origin
    (method url-fetch)
    (uri url)
    (file-name "wallpaper.png")
    (sha256 (base32 hash))))

(define wallpaper-ai-art
  (wallpaper "https://w.wallhaven.cc/full/j3/wallhaven-j3m8y5.png"
             "0qqx6cfx0krlp0pxrrw0kvwg6x40qq9jic90ln8k4yvwk8fl1nyw"))

(define wallpaper-dark-rider
  (wallpaper "https://w.wallhaven.cc/full/lm/wallhaven-lmlzwl.jpg"
             "01j5z3al8zvzqpig8ygvf7pxihsj2grsazg9yjiqyjgsmp00hpaf"))

(define (feature-additional-services)
  (feature-custom-services
   #:feature-name-prefix 'bryan
   #:system-services
    (list
     (service mate-desktop-service-type)
     (service sddm-service-type))
   #:home-services
   (list
    emacs-extra-packages-service
    home-extra-packages-service)))

(define dev-features
  (list
   (feature-markdown)))

(define virtualization-features
  (list
   (feature-docker)
   (feature-qemu)))

(define general-features
  (append
   rde-base
   rde-desktop
   rde-mail
   rde-cli
   rde-emacs))

(define %all-features
  (append
   virtualization-features
   dev-features
   general-features))

(define all-features-with-custom-kernel-and-substitutes
  (append
   ;; "C-h S" (info-lookup-symbol), "C-c C-d C-i" (geiser-doc-look-up-manual)
   ;; to see the info manual for a particular function.

   ;; Here we basically remove all the features which has feature name equal
   ;; to either 'base-services or 'kernel.
   (remove (lambda (f)
             (member
              (feature-name f)
              '(base-services
                swaylock
                git)))
           %all-features)
   (list
    (feature-swaylock
     #:swaylock (@ (gnu packages wm) swaylock-effects)
     ;; The blur on lock screen is not privacy-friendly.
     #:extra-config '((screenshots)
                      (effect-blur . 7x5)
                      (clock)))
    (feature-base-services
     #:default-substitute-urls (list "https://bordeaux.guix.gnu.org"
                                     "https://ci.guix.gnu.org")))))

(define-public %user-features
  (append
   all-features-with-custom-kernel-and-substitutes
   (list
    (feature-additional-services)
    (feature-user-info
     #:user-name "bryan"
     #:full-name "Bryan Paronto"
     #:email "bryan@cablecar.digital"
     #:user-initial-password-hash
     (crypt "bryan" "$6$abc")

     ;; WARNING: This option can reduce the explorability by hiding
     ;; some helpful messages and parts of the interface for the sake
     ;; of minimalistic, less distractive and clean look.  Generally
     ;; it's not recommended to use it.
     #:emacs-advanced-user? #t)

    ((@ (rde features terminals) feature-alacritty)
     #:config-file (local-file "../files/config/alacritty/alacritty.yml")
     #:default-terminal? #f
     #:backup-terminal? #t
     #:software-rendering? #f)
    (feature-emacs-keycast #:turn-on? #t)

    (feature-emacs-tempel
     #:default-templates? #t
     #:templates
     `(fundamental-mode
       ,#~""
       (t (format-time-string "%Y-%m-%d"))
       (todo
        (if (derived-mode-p 'lisp-data-mode 'clojure-mode 'scheme-mode)
            ";;"
            comment-start)
        (if (string-suffix-p " " comment-start) "" " ")
        "TODO"  ": [" user-full-name ", "
        (format-time-string "%Y-%m-%d") "] ")))
    (feature-emacs-time)
    (feature-emacs-spelling
     #:spelling-program (@ (gnu packages hunspell) hunspell)
     #:spelling-dictionaries
     (list
      (@ (gnu packages hunspell) hunspell-dict-en)))
    (feature-emacs-git
     #:project-directory "/home/bryan/src")
    (feature-emacs-org
     #:org-directory "/home/bryan/org"
     #:org-indent? #f
     #:org-capture-templates
     `(("r" "Reply" entry (file+headline "" "Tasks")
        "* TODO %:subject %?\nSCHEDULED: %t\n%U\n%a\n"
        :immediate-finish t)
       ("t" "Todo" entry (file+headline "" "Tasks") ;; org-default-notes-file
        "* TODO %?\nSCHEDULED: %t\n%a\n")))
    (feature-emacs-org-roam
     ;; TODO: Rewrite to states
     #:org-roam-directory "/home/bryan/notes")
    (feature-emacs-org-agenda
     #:org-agenda-files '("/home/bryan/org/todo.org"))
    (feature-emacs-elfeed
     #:elfeed-org-files '("/home/bryan/org/rss.org"))

    (feature-javascript)

    (feature-keyboard
     #:keyboard-layout
     (keyboard-layout
      "us,en"
      #:options '("ctrl:nocaps"))))))
