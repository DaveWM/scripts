#! /usr/bin/hy

(import harvest datetime [config [harvest-config slack-config]] [slacker [Slacker]])

(def min-hours 5)

(def today (datetime.date.today))
(def last-monday (- today
                    (datetime.timedelta (.weekday today))
                    (datetime.timedelta 7)))

(def harvest-client
  (harvest.Harvest (:url harvest-config) (:email harvest-config) (:password harvest-config)))
(def slack-client (Slacker (:token slack-config)))


(defn get-harvest-entries [start-date num-days]
  (->> (range 0 num-days)
       (map (fn [i] (+ start-date (datetime.timedelta i))))
       (map (fn [d]
              (setv year-day (-> d .timetuple (. tm-yday))
                    year (. d year))
              (-> (.get_day harvest-client year-day year)
                  (get "day_entries"))))
       (reduce +)))

(defn post-slack-message [user-id message]
  (setv dm-channel-id (-> slack-client
                          (. im)
                          (.open user-id)
                          (. body)
                          (get "channel")
                          (get "id")))
  (-> slack-client
      (. chat)
      (.post-message dm-channel-id message)))


(defn main []
  (setv entries (get-harvest-entries last-monday 5)
        warning-entries (->> entries
                             (filter (fn [e] (> min-hours (get e "hours")))))
        num-missing-days (len (list warning-entries)))
  (if num-missing-days
    (do (post-slack-message (:user-id slack-config) (+ "Update your harvest, missing " (str num-missing-days) " days last week"))
        (print "Warned user"))
    (print "All fine")))

(main)

