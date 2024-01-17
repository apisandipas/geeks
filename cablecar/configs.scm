(define-module (cablecar configs)
  #:use-module (gnu services)
  #:use-module (rde packages)
  #:use-module (rde features)
  #:use-module (rde features base)
  #:use-module (rde features wm)
  #:use-module (rde features xdisorg)
  #:use-module (rde features xdg)
  #:use-module (rde features version-control)
  #:use-module (rde features fontutils)
  #:use-module (rde features terminals)
  #:use-module (rde features tmux)
  #:use-module (rde features shells)
  #:use-module (rde features shellutils)
  #:use-module (rde features ssh)
  #:use-module (rde features emacs)
  #:use-module (rde features linux)
  #:use-module (rde features bittorrent)
  #:use-module (rde features docker)
  #:use-module (rde features video)
  #:use-module (rde features finance)
  #:use-module (rde features markup)
  #:use-module (rde features mail)
  #:use-module (rde features networking)
  #:use-module (gnu services)
  #:use-module (gnu services desktop)
  #:use-module (gnu services sddm)
  #:use-module (gnu system)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (rde packages)
  #:use-module (rde packages emacs)
  #:use-module (rde packages emacs-xyz)
  #:use-module (gnu packages fonts)
  #:use-module (guix gexp)
  #:use-module (guix inferior)
  #:use-module (guix channels)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (ice-9 match)
  #:use-module (cablecar utils)
  ;; #:use-module (cablecar configs)
  #:use-module (cablecar features state)
  #:use-module (cablecar features emacs)
  #:use-module  (cablecar packages emacs-xyz)
  #:export (%base-features))


(define %base-features
  (append
   (list
    ;; (feature-bash)
    ;; (feature-direnv)
    ;; (feature-git)
    ;; (feature-ssh)
    (feature-xdg
     #:xdg-user-directories-configuration
     (home-xdg-user-directories-configuration
      (music "$HOME/music")
      (videos "$HOME/vids")
      (pictures "$HOME/pics")
      (documents "$HOME/docs")
      (download "$HOME/dl")
      (desktop "$HOME")
      (publicshare "$HOME")
      (templates "$HOME")))
    (feature-base-packages
     #:system-packages
     (list cablecar-emacs-exwm)
     #:home-packages
     (append
      (list cablecar-emacs-exwm)
      ;; (pkgs-vanilla
      ;;  "icecat" "nyxt"
      ;;  "ungoogled-chromium" "ublock-origin-chromium")
      (pkgs
       "firefox"
       "neofetch"
       "arandr"
       "dunst"
       "nm-tray"
       "pasystray"
       "emacs-desktop-environment"
       "alsa-utils" "youtube-dl" "imv"
       "obs" "obs-wlrobs"
       "rofi"
       "recutils"
       "fheroes2"
       "feh" "picom" "polybar"
       "hicolor-icon-theme" "adwaita-icon-theme" "gnome-themes-extra"
       "ripgrep" "curl" "make")))
    (feature-dotfiles
     #:dotfiles
     `(
       (".exwm" ,(local-file "files/config/emacs/exwm"))
       (".config/dunst/dunstrc" ,(local-file "files/config/dunst/dunstrc"))
       (".config/polybar/config" ,(local-file "files/config/polybar/config.ini"))
       (".config/rofi/config.rasi" ,(local-file "files/config/rofi/config.rasi"))
       )
     )
    )

   %cablecar-base-emacs-packages
   ))
