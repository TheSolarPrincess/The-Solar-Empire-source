;; <(Activate)>

(defvar project-base "~/Workspace/Muse")
(defun path (rel-path) (expand-file-name rel-path project-base))

(require 'org-attach)
(defun read-file (file)
  "File to string function"
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(let ((org-publish-use-timestamps-flag t)
      (org-confirm-babel-evaluate nil)
      (org-html-include-default-figure nil)
      (org-export-default-language "ru")
      (org-export-allow-bind-keywords t)
                                        ;(org-link-abbrev-alist '(("attachment" . "///attachment/%s")))
      (org-export-global-macros
       '(("localize"
          . "@@html:<div style=\"text-align:center;\">@@src_elisp[:results value raw]{(temp/translation)}@@html:</div>@@")
         ("main-ru"
          . "@@html:<nav class=\"org-div-home-and-up\">@@src_elisp[:results value raw]{(temp/mru)}@@html:</nav>@@")
         ("main-en"
          . "@@html:<div style=\"text-align:center;\">@@src_elisp[:results value raw]{(temp/men)}@@html:</div>@@")
         ("post-ru"
          . "@@html:<div style=\"text-align:center;\">@@src_elisp[:results value raw]{(temp/ru)}@@html:</div>@@")
         ("post-en"
          . "@@html:<div style=\"text-align:center;\">@@src_elisp[:results value raw]{(temp/en)}@@html:</div>@@")
         ))
      (org-html-postamble-format `(("en"  ,(read-file  "~/Workspace/muse/source/assets/misc/umami"))))
      (org-publish-project-alist
       `(
         ("orgfiles"
          :base-directory ,(path "source/")
          :publishing-directory ,(path "out/")
          :publishing-function org-html-publish-to-html
          :recursive t
          :preserve-breaks t
          :with-author nil
          :with-broken-links nil
          :section-numbers nil
          :exclude-tags ("noexport")
          :html-self-link-headlines nil
          :with-latex t
          :with-toc nil
          :with-tables t
          :with-tags nil
          :with-tasks nil

          :with-timestamps t
          :with-title t
          :auto-sitemap nil
          :sitemap-title "The Solar Empire"
          :sitemap-filename "index.html"
          :html-doctype "html5"
          :html-subtitle "Site of The Solar Princess"
          :html-head-include-default-style nil
          :html-use-infojs nil
          :html-preamble t
          :html-postamble t
          :sitemap-style list
          :sitemap-sort-files alphabetically
          ;; :makeindex t
          :html-html5-fancy t
          :html-head "<link rel=\"stylesheet\" href=\"/assets/css/style.css\">"
          ;;:html-head-extra
          :html-footnotes-section "<hr> %2$s"
          )
                                        ;
         ("attachments"
          :base-directory ,(path "source/attachment")
          :recursive t
          :publishing-directory  ,(path "out/attachment")
          :base-extension any
          :publishing-function org-publish-attachment
          )
         ("assets"
          :base-directory ,(path "source/assets")
          :recursive t
          :publishing-directory  ,(path "out/assets")
          :base-extension any
          :publishing-function org-publish-attachment
          )

         ))
      )
  (progn
    (defun temp/navbar (value) (concat "<nav id=\"org-div-home-and-up\">" value "</nav>"))
    (defun temp/translation ()
      (let* ((this-file (buffer-file-name))
             (base-name (file-name-base this-file))
             (folder-a (path "source/blog/en/"))
             (folder-b (path "source/blog/"))
             (other-folder (if (string-prefix-p folder-a this-file)
                               folder-b
                             folder-a))
             (lang (if (string-prefix-p folder-a this-file)
                       "en"
                     "ru"))
             (target (if (string-equal "en" lang)
                         "🇷🇺 Русская версия"
                       "🇺🇸 English version"))
             (other-file (expand-file-name (concat base-name ".org") other-folder))
             (other-html
              ((lambda (name)
                 (if (string-equal "en" lang)
                     (concat "blog/" name ".html")
                   (concat "blog/en/" name ".html"))
                 ) base-name)))
        (if (file-exists-p other-file)
            (format "<a href=\"/%s\">%s</a>" other-html target)
          (if (string-equal "en" lang) "🇷🇺 Русской версии пока нет" "🇺🇸 No English translation yet")
          )
        ))
    (defun temp/fictranslation ()
      (let* ((this-file (buffer-file-name))
             (base-name (file-name-base this-file))
             ;; adjust paths here:
             (folder-a (path "source/fiction/en/"))
             (folder-b (path "source/fiction/"))
             (other-folder (if (string-prefix-p folder-a this-file)
                               folder-b
                             folder-a))
             (lang (if (string-prefix-p folder-a this-file)
                       "en"
                     "ru"))
             (target (if (string-equal "en" lang)
                         "🇷🇺 Русская версия"
                       "🇺🇸 English version"))
             (other-file (expand-file-name (concat base-name ".org") other-folder))
             (other-html
              ((lambda (name)
                 (if (string-equal "en" lang)
                     (concat "fiction/" name ".html")
                   (concat "fiction/en/" name ".html"))
                 ) base-name)))
        (if (file-exists-p other-file)
            (format "<a href=\"/%s\">%s</a>" other-html target)
          (if (string-equal "en" lang) "🇷🇺 Русской версии пока нет" "🇺🇸 No English translation yet")
          )
        ))
    (defun temp/main-header-ru () (temp/navbar "<a href=\"/en.html\">🇺🇸 English version</a>"))
    (defun temp/main-header-en () (temp/navbar "<a href=\"/index.html\">🇷🇺 Русская версия</a>"))
    (defun temp/home-header-ru () (temp/navbar "UNUSED"))
    (defun temp/locl-header-en () (temp/navbar (concat "<a href=\"/en.html\">Main page</a> | " (temp/translation))))
    (defun temp/locl-header-ru () (temp/navbar (concat "<a href=\"/index.html\">Главная страница</a> | " (temp/translation))))
    (defun temp/fiction-header-en () (temp/navbar (concat "<a href=\"/en.html\">Main page</a> | " (temp/translation))))
    (defun temp/fiction-header-ru () (temp/navbar (concat "<a href=\"/index.html\">Главная страница</a> | " (temp/translation))))
    (defun temp/proper-header  (kind)
      (pcase kind
        ("main-ru" (temp/main-header-ru))
        ("main-en" (temp/main-header-en))
        ("ru" (temp/locl-header-ru))
        ("en" (temp/locl-header-en))
        (_ "")
        )
      )
    (defun temp/mru () (temp/proper-header "main-ru"))
    (defun temp/men () (temp/proper-header "main-en"))
    (defun temp/ru () (temp/proper-header "ru"))
    (defun temp/en () (temp/proper-header "en"))
    (defun temp/org-set-head-extra (backend)
      (when (org-export-derived-backend-p backend 'html)
        (let* ((file (buffer-file-name))
               (extra (temp/html-head-extra-function file)))
          (setq-local org-html-head-extra extra))))

    (defun temp/html-head-extra-function (file)
      (cond
       ((string-match-p "index.org$" file) (temp/main-header-ru))
       ((string-match-p "en.org$" file) (temp/main-header-en))
       ((string-match-p "blog/en/.*$" file)  (temp/locl-header-en))
       ((string-match-p "fiction/en/.*$" file)  (temp/fiction-header-en))
       ((string-match-p "fiction/.*$" file)  (temp/fiction-header-ru))
       ((string-match-p "blog/.*$" file)
        (temp/navbar (concat "<a href=\"/index.html\">Главная страница</a> | " (temp/translation))))
       (t file)))
    (add-hook 'org-export-before-processing-hook #'temp/org-set-head-extra)
    (org-publish-all)
    (remove-hook 'org-export-before-processing-hook #'temp/org-set-head-extra)
    (let ((default-directory (path "rss"))) (load-file (path "rss/code.el")))
    )
  )
