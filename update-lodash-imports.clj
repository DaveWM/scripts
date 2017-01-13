(ns update-lodash-imports)

(def import-regex #"import \* as _ from 'lodash';?")
(def usage-regex #"\_\.([^\(\.\)]+)")

(defn re-find-all [pattern string]
  (let [matcher (re-matcher pattern string)]
    (loop [match (re-find matcher)
           matches []]
      (if match
        (recur (re-find matcher) (conj matches match))
        matches))))

(defn get-ts-files [dir-path]
  (->> (file-seq (clojure.java.io/file dir-path))
       (filter #(clojure.string/includes? (.getName %) ".ts"))))

(defn process-file [file-contents]
  (when (re-find import-regex file-contents)
    (let [usages (into #{} (re-find-all usage-regex file-contents))
          imports (->> usages
                       (map (fn [[usage func-name]]
                              (str "import " func-name " from 'lodash/" func-name "';")))
                       (clojure.string/join "\n"))
          file-with-updated-usages (->> usages
                                        (reduce (fn [f [usage func-name]]
                                                  (clojure.string/replace f usage func-name))
                                                file-contents))]
      (-> (str imports "\n" file-with-updated-usages)
          (clojure.string/replace import-regex "")))))

(defn fix-lodash [dir-path]
  (let [files (get-ts-files dir-path)
        updates (->> files
                     (map (juxt identity slurp))
                     (map (fn [[name contents]]
                            [name (process-file contents)]))
                     (filter (fn [[_ contents]]
                               contents)))]
    (println (count updates))
    (doseq [[file new-contents] updates]
      (spit file new-contents))))
