;; <(Activate)>
(let  ((org-publish-use-timestamps-flag t)
       (org-html-head-include-default-style nil)
       (org-html-head-include-scripts nil)
       (org-html-preamble nil)
       (org-html-postamble nil)
       (org-html-with-latex t)
       (org-html-)
       (org-html-doctype "html5")
       (org-publish-project-alist
        `(
          ("rufiles"
           :base-directory "../source/blog"
           :publishing-directory "./data/"
           :publishing-function org-html-publish-to-html
           :recursive nil
           :preserve-breaks t
           :with-author nil
           :with-broken-links nil
           :section-numbers nil
           :exclude-tags ("noexport")
           :html-self-link-headlines nil
           :with-toc nil
           :with-tables t
           :with-tags nil
           :with-tasks nil
           :with-timestamps nil
           :with-title nil
           :auto-sitemap nil
           :html-doctype "html5"
           :html-html5-fancy t
           )

          ("enfiles"
           :base-directory "../source/blog/en"
           :publishing-directory "./data-en"
           :publishing-function org-html-publish-to-html
           :recursive nil
           :preserve-breaks t
           :with-author nil
           :with-broken-links nil
           :section-numbers nil
           :exclude-tags ("noexport")
           :html-self-link-headlines nil
           :with-toc nil
           :with-tables t
           :with-tags nil
           :with-tasks nil
           :with-timestamps nil
           :with-title nil
           :auto-sitemap nil
           :html-doctype "html5"
           :html-html5-fancy t
           )
          )))
  (org-publish-all)
  (shell-command "bb ./script/run.clj")
  (shell-command "cp feed_ru.rss ../out/feed_ru.rss")
  (shell-command "cp feed_en.rss ../out/feed_en.rss")
  )
