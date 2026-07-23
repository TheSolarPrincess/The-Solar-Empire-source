(ns blog-rss
  (:require
   [babashka.fs :as fs]
   [clojure.java.io :as io]
   ))
(import '[org.jsoup Jsoup]
        '[org.jsoup.nodes Document Element])


(defn add-class! [^Element el class]
  (when el
    (.addClass el class)))

(defn process-file [input output ]
  #_(print "CLJ PROCESSING" input)
  (let [doc (Jsoup/parse (io/file input) "UTF-8")]

    ;; body
    (add-class! (.body doc) "h-entry")

    ;; title
    (when-let [title (.selectFirst doc "h1.title")]
      (add-class! title "p-name"))

    ;; main content
    (when-let [content (.selectFirst doc "div.content")]
      (add-class! content "e-content"))
    (when-let [content (.selectFirst doc "article.content")]
      (add-class! content "e-content"))

    ;; summary
    (when-let [content (.selectFirst doc "div.content > p")]
      (add-class! content "p-summary"))
    (when-let [content (.selectFirst doc "article.content > p")]
      (add-class! content "p-summary"))
    ;; syndication links
    (doseq [a (drop 3 (.select doc "#postamble a"))]
                                        ; ignoring email and permalink and anonymous
      (.addClass a "u-syndication"))

    ;; permalink
    (when-let [link (.selectFirst doc "#postamble #permalink")]
      (.addClass link "u-url")
      (.attr link "visibility" "hidden")
      (.attr link "aria-hidden" "true")
      (.attr link "tabindex" "-1")
      )

    (spit output (.outerHtml doc))))

(apply process-file *command-line-args*)
