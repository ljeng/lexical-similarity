(defn kahn [graph n]
  (def inverse (zipmap (range n) (repeat #{})))
  (doseq [u (keys graph)]
    (doseq [v (graph u)]
      (swap! inverse update-in [v] conj u)))

  (def stack (filter #(empty? (inverse %)) (range n)))
  (def order (atom []))

  (while (seq stack)
    (let [u (peek stack)]
      (swap! order conj u)
      (doseq [v (vec (graph u))]
        (swap! graph update-in [u] disj v)
        (swap! inverse update-in [v] disj u)
        (when (empty? (inverse v))
          (swap! stack conj v))))

  (if (= (count @order) n)
    @order
    "Cyclic graph"))

(def input-file (slurp "input.txt"))
(defn write-output [output]
  (with-open [output-file (clojure.java.io/writer "output.txt")]
    (doseq [line output]
      (println output-file line))))

(defn -main []
  (let [lines (clojure.string/split-lines input-file)
        t (Integer. (first lines))
        data (rest lines)
        output (atom [])]
    (loop [t t
           data data]
      (when (pos? t)
        (let [n (Integer. (first data))]
          (def graph (zipmap (range n) (repeat #{})))
          (def data (rest data))
          (loop [data data]
            (let [line (first data)]
              (if (empty? line)
                (do
                  (swap! output conj (kahn graph n))
                  (def data (rest data))
                  (recur data))
                (let [u v (map read-string (clojure.string/split line #" "))]
                  (swap! graph update-in [u] conj v)
                  (recur (rest data))))))))
        (recur (dec t) (rest data))))
    (write-output @output)))

(-main)
