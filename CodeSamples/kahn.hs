import Data.Default
import Data.Set (Set)

kahn :: [(Int, Int)] -> Int -> [Int]
kahn graph n =
  let inverse = foldr (\(u, v) -> insert v u inverse) mempty graph
  in kahn' stack inverse
  where
    stack = filter (not . isJust . flip lookup inverse) [0 .. n - 1]
    kahn' [] _ = []
    kahn' (u:us) inverse =
      u : kahn' (filter (not . isJust . flip lookup inverse) (us ++ (graph $! u))) (remove u inverse)
    remove u = map (delete u)

main :: IO ()
main = do
  inputFile <- openFile "input.txt" ReadMode
  outputFile <- openFile "output.txt" WriteMode
  putStrLn outputFile $ unlines $ map (show . kahn) $ (take (read $ getLine inputFile) . repeat) $ (drop 1 . lines) <$> readFile inputFile
  hClose inputFile
  hClose outputFile
