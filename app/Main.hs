{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
module Main where

import           Control.Lens           ((.=))
import           Data.Version           (showVersion)
import           Paths_Taiji            (version)
import           Scientific.Workflow
import           Text.Printf            (printf)

import qualified Taiji.Core             as Core
import qualified Taiji.Extra            as Extra
import qualified Taiji.Pipeline.ATACSeq as ATACSeq
import qualified Taiji.Pipeline.RNASeq  as RNASeq
import           Taiji.Types            (TaijiConfig)

mainWith defaultMainOpts
    { programHeader = printf "Taiji-v%s" $ showVersion version } $ do
        namespace "RNA" RNASeq.builder
        namespace "ATAC" ATACSeq.builder
        Core.builder
        Extra.builder
        path ["ATAC_Call_Peak", "Find_Active_Promoter"]
        [ "Find_Active_Promoter", "ATAC_Get_TFBS", "ATAC_Call_Peak"
            , "RNA_Make_Expr_Table", "HiC_Read_Input" ] ~> "Compute_Ranks_Prep"
