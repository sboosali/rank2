import Rank2
import Criterion.Main

main :: IO ()
main = defaultMain [
  bgroup "Rank2"
    [ bench "1" $ nf   length [1..1000::Int]
    , bench "2" $ whnf length [1..1000::Int]
    ]
  ]

