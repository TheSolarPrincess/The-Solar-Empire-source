(ns process
  (:require
   [babashka.fs :as fs]
   [clojure.string :as str]
   ))

(def template
  "<!DOCTYPE html>
  <html lang=\"en\">
  <head>
  <meta charset=\"UTF-8\">
  <meta http-equiv=\"refresh\" content=\"0; url=%s\">
  <link rel=\"canonical\" href=\"%s\">
  <title>Redirecting...</title>
  </head>
  <body>
  <p>If you are not redirected automatically, <a href=\"%s\">click here</a>.</p>
  </body>
  </html>"
  )

(defn mk-html [filename]
  (format template
          (str "/blog/ru/" (str/replace filename ".org" ".html"))
          (str "https://thesolarprincess.org/blog/ru/" (str/replace filename ".org" ".html"))
          (str "/blog/ru/" (str/replace filename ".org" ".html"))
          ))

(doseq
    [filename (map str (fs/glob "." "**{.org}"))]
  (spit (str/replace filename ".org" ".html") (mk-html filename))
  )
