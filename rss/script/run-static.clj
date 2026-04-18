(ns blog-rss
  (:require [clj-rss.core :as rss]
            [babashka.fs :as fs]
            [clojure.string :as str]
            [clojure.edn :as edn]
            ))

(def author "TheSunWorshipper@protonmail.com")
(defn lnk [filename] (str "https://thesolarprincess.github.io/" filename))

(defn extract-body [html-content]
  "Extract content between <body> and </body> tags"
  (when-let [match (re-find #"(?s)<body[^>]*>(.*?)</body>" html-content)]
    (second match)))

(defn extract-title [html-content]
  "Extract content between <title> and </title> tags"
  (when-let [match (re-find #"(?s)<title[^>]*>(.*?)</title>" html-content)]
    (str/trim (second match))))

(def document
  (memoize
   (fn [filename] (slurp (str "out/" filename)))))

(defn process [posts feeds]
  (doseq [[feed-k feed-dict] feeds]
    (let [builder
          (fn [[filename datetime _]]
            {:title (extract-title (document filename))
             :description (extract-body (document filename))
             :link (lnk filename) :author author :pubDate (java.time.Instant/parse datetime)})

          entries
          (filter #(some #{feed-k} %) posts)

          out
          (rss/channel-xml
           {:title (:title feed-dict)
            :link (lnk "")
            :description (:description feed-dict)}
           (map builder entries))]
      (spit (str "out/" (:path feed-dict)) out))))

(defn -main []
  (let [file-path (first *command-line-args*)
        data      (edn/read-string (slurp file-path))]
    (process (:posts data) (:feeds data))))
(-main)
