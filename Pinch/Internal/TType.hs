{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE RankNTypes         #-}
{-# LANGUAGE StandaloneDeriving #-}
-- |
-- Module      :  Pinch.Internal.TType
-- Copyright   :  (c) Abhinav Gupta 2015
-- License     :  BSD3
--
-- Maintainer  :  Abhinav Gupta <mail@abhinavg.net>
-- Stability   :  experimental
--
-- Defines the different types Thrift supports at the protocol level.
--
module Pinch.Internal.TType
    (
    -- * TType

    -- | TType is used to refer to the protocol-level Thrift type of a value.
    --
    -- For most basic types, it's just that type: @bool@, @byte@, etc. For
    -- @string@ and @binary@, it's always @binary@; Thrift doesn't
    -- differentiate between text and binary at the protocol level. Enums use
    -- @i32@, and all structs, exceptions, and unions use @struct@.

      TType(..)
    , IsTType(..)
    , SomeTType(..)

    -- * Tags

    , TBool
    , TByte
    , TDouble
    , TInt16
    , TInt32
    , TInt64
    , TBinary
    , TStruct
    , TMap
    , TSet
    , TList
    ) where

import Data.Hashable (Hashable (..))
import Data.Typeable (Typeable)

-- | @bool@
data TBool   deriving (Typeable)

-- | @byte@
data TByte   deriving (Typeable)

-- | @double@
data TDouble deriving (Typeable)

-- | @i16@
data TInt16  deriving (Typeable)

-- | @i32@
data TInt32  deriving (Typeable)

-- | @i64@
data TInt64  deriving (Typeable)

-- | @binary@ and @string@
data TBinary deriving (Typeable)

-- | @struct@, @union@, and @exception@
data TStruct deriving (Typeable)


-- | @map\<k, v\>@
data TMap    deriving (Typeable)

-- | @set\<x\>@
data TSet    deriving (Typeable)

-- | @list\<x\>@
data TList   deriving (Typeable)


-- | Represents the type of a Thrift value.
--
-- Objects of this type are tagged with one of the TType tags, so this type
-- also acts as a singleton on the TTypes. It allows writing code that can
-- enforce properties about the TType of values at compile time.
data TType a where
    TBool   :: TType TBool    -- 2
    TByte   :: TType TByte    -- 3
    TDouble :: TType TDouble  -- 4
    TInt16  :: TType TInt16   -- 6
    TInt32  :: TType TInt32   -- 8
    TInt64  :: TType TInt64   -- 10
    TBinary :: TType TBinary  -- 11
    TStruct :: TType TStruct  -- 12
    TMap    :: TType TMap     -- 13
    TSet    :: TType TSet     -- 14
    TList   :: TType TList    -- 15
  deriving (Typeable)

deriving instance Show (TType a)
deriving instance Eq (TType a)

instance Hashable (TType a) where
    hashWithSalt s TBool   = s `hashWithSalt` (0  :: Int)
    hashWithSalt s TByte   = s `hashWithSalt` (1  :: Int)
    hashWithSalt s TDouble = s `hashWithSalt` (2  :: Int)
    hashWithSalt s TInt16  = s `hashWithSalt` (3  :: Int)
    hashWithSalt s TInt32  = s `hashWithSalt` (4  :: Int)
    hashWithSalt s TInt64  = s `hashWithSalt` (5  :: Int)
    hashWithSalt s TBinary = s `hashWithSalt` (6  :: Int)
    hashWithSalt s TStruct = s `hashWithSalt` (7  :: Int)
    hashWithSalt s TMap    = s `hashWithSalt` (8  :: Int)
    hashWithSalt s TSet    = s `hashWithSalt` (9  :: Int)
    hashWithSalt s TList   = s `hashWithSalt` (10 :: Int)


-- | Typeclass used to map type-leve TTypes into 'TType' objects. All TType
-- tags are instances of this class.
class Typeable a => IsTType a where
    -- | Base on the context in which this is used, it will automatically
    -- return the corresponding 'TType' object.
    ttype :: TType a


instance IsTType TBool   where ttype = TBool
instance IsTType TByte   where ttype = TByte
instance IsTType TDouble where ttype = TDouble
instance IsTType TInt16  where ttype = TInt16
instance IsTType TInt32  where ttype = TInt32
instance IsTType TInt64  where ttype = TInt64
instance IsTType TBinary where ttype = TBinary
instance IsTType TStruct where ttype = TStruct
instance IsTType TMap    where ttype = TMap
instance IsTType TSet    where ttype = TSet
instance IsTType TList   where ttype = TList


-- | Used when the 'TType' for something is not known at compile time.
-- Typically, this will be pattern matched inside a case statement and code
-- that depends on the TType will be go there.
data SomeTType where
    SomeTType :: forall a. IsTType a => TType a -> SomeTType
  deriving Typeable

deriving instance Show SomeTType
