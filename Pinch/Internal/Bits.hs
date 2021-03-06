{-# LANGUAGE CPP       #-}
{-# LANGUAGE MagicHash #-}
-- |
-- Module      :  Pinch.Internal.Bits
-- Copyright   :  (c) Abhinav Gupta 2015
-- License     :  BSD3
--
-- Maintainer  :  Abhinav Gupta <mail@abhinavg.net>
-- Stability   :  experimental
--
-- Provides unchecked bitwise shift operations. Similar versions of @shiftR@
-- are used by @ByteString.Builder.Prim@.
module Pinch.Internal.Bits
    ( w16ShiftL
    , w32ShiftL
    , w64ShiftL
    ) where

#if defined(__GLASGOW_HASKELL__) && !defined(__HADDOCK__) && !defined(ghcjs_HOST_OS)
import GHC.Base (Int (..), uncheckedShiftL#)
import GHC.Word (Word16 (..), Word32 (..), Word64 (..))
#else
import Data.Bits (shiftL)
import Data.Word (Word16, Word32, Word64)
#endif

{-# INLINE w16ShiftL #-}
w16ShiftL :: Word16 -> Int -> Word16

{-# INLINE w32ShiftL #-}
w32ShiftL :: Word32 -> Int -> Word32

{-# INLINE w64ShiftL #-}
w64ShiftL :: Word64 -> Int -> Word64

-- If we're not on GHC, the regular shiftL will be returned.

#if defined(__GLASGOW_HASKELL__) && !defined(__HADDOCK__) && !defined(ghcjs_HOST_OS)
w16ShiftL (W16# w) (I# i) = W16# (w `uncheckedShiftL#` i)
w32ShiftL (W32# w) (I# i) = W32# (w `uncheckedShiftL#` i)
w64ShiftL (W64# w) (I# i) = W64# (w `uncheckedShiftL#` i)
#else
w16ShiftL = shiftL
w32ShiftL = shiftL
w64ShiftL = shiftL
#endif
