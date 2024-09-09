import Lake
open Lake DSL

def leanVersion : String := s!"v{Lean.versionString}"

package «IMO_2024» where
  -- add package configuration options here

lean_lib «IMO2024» where
  -- add library configuration options here

require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ leanVersion

@[default_target]
lean_exe «imo_2024» where
  root := `Main
