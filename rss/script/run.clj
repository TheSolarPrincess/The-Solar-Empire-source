(ns blog-rss
  (:require [clj-rss.core :as rss]
            [babashka.fs :as fs]
            [clojure.string :as str]
            ))

(defn extract-body [html-content]
  "Extract content between <body> and </body> tags"
  (when-let [match (re-find #"(?s)<body[^>]*>(.*?)</body>" html-content)]
    (second match)))

(defn extract-title [html-content]
  "Extract content between <title> and </title> tags"
  (when-let [match (re-find #"(?s)<title[^>]*>(.*?)</title>" html-content)]
    (str/trim (second match))))

(defn format-time [time]
  (if (nil? time) nil (java.time.Instant/parse time)))

(def dates-ru
  {"psychometaphysics.html" "2025-11-30T10:15:30.00Z"
   "whatwoman.html" "2023-11-30T10:15:30.00Z"})

(def dates-en
  {"psychometaphysics.html" "2025-11-30T10:15:30.00Z"
   "badwords.html" "2025-12-04T10:15:30.00Z" })


(defn sort-entries [x]
  (sort-by
   (fn [[_ instant _]]
     (if instant
       instant
       (java.time.Instant/MIN)))
   #(compare %2 %1)
   x))


(defn -main-ru []
  (let [dir "./data"
        url #(str/replace-first % "data" "https://thesolarprincess.site/blog")
        files (fs/glob dir "**{.htm,html}")
        builder #(into {
                        :title (extract-title (nth % 2))
                        :description (extract-body (nth % 2))
                        :link (nth % 0)
                        :author "inbox@thesolarprincess.site"
                        }
                       (if (nil? (nth % 1)) {} {:pubDate (nth % 1)}))
        urls (->>
              files
              (map str)
              (map url)
              (into []))

        datetimes (as->
                      files x
                    (map str x)
                    (map #(clojure.string/split % #"/") x)
                    (map last x)
                    (map dates-ru x)
                    (map format-time x)
                    )

        data (->>
              files
              (map str)
              (map slurp)
              (map vector urls datetimes)
              (sort-entries)
              (map builder)
              (into []))

        out (rss/channel-xml
             {:title "Вспышки на Солнце"
              :link "https://thesolarprincess.site/"
              :description "Набор письмен Солнечной Принцессы"}
             data)

        ]
    #_(print (map :title data))
    (spit "./feed_ru.rss" out)))

(defn -main-en []
  (let [dir "./data-en"
        url #(str/replace-first % "data-en" "https://thesolarprincess.site/blog/en")
        files (fs/glob dir "**{.htm,html}")
        builder #(into {
                        :title (extract-title (nth % 2))
                        :description (extract-body (nth % 2))
                        :link (nth % 0)
                        :author "inbox@thesolarprincess.site"
                        }
                       (if (nil? (nth % 1)) {} {:pubDate (nth % 1)}))
        urls (->>
              files
              (map str)
              (map url)
              (into []))

        datetimes (as->
                      files x
                    (map str x)
                    (map #(clojure.string/split % #"/") x)
                    (map last x)
                    (map dates-en x)
                    (map format-time x)
                    )

        data (->>
              files
              (map str)
              (map slurp)
              (map vector urls datetimes)
              (sort-entries)
              (map builder)
              (into []))
        out (rss/channel-xml
             {:title "Solar Flares"
              :link "https://thesolarprincess.site/en"
              :description "Collected writings of the Solar Princess"}
             data)

        ]
    (spit "./feed_en.rss" out)))

(defn -main []
  (-main-ru)
  (-main-en))

(-main)
