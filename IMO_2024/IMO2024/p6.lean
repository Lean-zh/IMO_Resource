import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Data.Set.Card
import Mathlib.Tactic.Continuity
import Mathlib.Tactic.Have

open Polynomial

/--
Let $\mathbb{Q}$ be the set of rational numbers. A function $f : \mathbb{Q} \to \mathbb{Q}$ is called \emph{aquaesulian} if
the following property holds: for every $x, y \in \mathbb{Q}$,
$$
f(x + f(y)) = f(x) + y \qquad\text{or}\qquad f(f(x) + y) = x + f(y).
$$
Show that there exists an integer $c$ such that for any aquaesulian function $f$ there are at most
$c$ different rational numbers of the form $f(r) + f(-r)$ for some rational number $r$, and find the
smallest possible value of $c$.

Solution: c=2
-/
theorem imo_2024_p6
    (IsAquaesulian : (ℚ → ℚ) → Prop)
    (IsAquaesulian_def : ∀ f, IsAquaesulian f ↔
      ∀ x y, f (x + f y) = f x + y ∨ f (f x + y) = x + f y) :
    IsLeast {(c : ℤ) | ∀ f, IsAquaesulian f → {(f r + f (-r)) | (r : ℚ)}.Finite ∧
      {(f r + f (-r)) | (r : ℚ)}.ncard ≤ c} 2 := by
  exists@?_
  · /- Let f be an aquaesulian function with f(0) = 0.
        We claim that f(x) + f(-x) takes on at most two distinct values. -/
    useλu b=>if j:u 0=0then by_contra λc=>?_ else ?_
    · -- If f(x) + f(-x) = 0 for all x, we are done.
      suffices:({J|∃k,u k+u (-k)= J}) ⊆{0}
      · simp_all[this.antisymm]
      -- Otherwise, take a, k such that f(a) + f(-a) = k ≠ 0.
      rintro - ⟨a, rfl⟩
      contrapose! c
      simp_all
      -- If we can show that f(x) + f(-x) = 0 or k for all x, then we are done.
      suffices:{U|∃examples6, (u) ‹ℚ› +u ( -‹_›)= U} ⊆{0,(u (a : Rat)+ (u<|@@↑(( (-a ))))) } ..
      · use ( Set.toFinite ( _) ).subset ↑@@this , (Set.ncard_le_ncard$ (((this )) ) ).trans (Set.ncard_pair$ Ne.symm (↑ ( (c)) ) ).le
      -- We now proceed to show that f(x) + f(-x) = 0 or k for all x.
      rintro-⟨hz, rfl⟩
      -- We have f(x + f(a)) = f(x) + a or f(f(x) + a) = x + f(a).
      induction b @hz a
      · -- Step "f.": First, consider the case where f(x + f(a)) = f(x) + a.
        /- Step "i.": We have f(-a + f(x + f(a))) = f(-a) + (x + f(a))
            or f(f(-a) + (x + f(a))) = -a + f(x + f(a)). -/
        have:=b (-a)$ hz+u a
        /- Step "ii.": We have f(x + f(x)) = f(x) + x or f(f(x) + x) = x + f(x).
            This simplifies to just f(x + f(x)) = x + f(x).
        -/
        have:=b hz hz
        /- Step "iii.": Substituting step “f.” into step “i.” and simplifying
            gives f(f(x)) = x + f(a) + f(-a) or f(x + f(a) + f(-a)) = f(x). -/
        simp_all[add_comm]
        /- Step "iiii.": We have f(-x + f(x + f(x))) = f(-x) + x + f(x) or
            f(f(-x) + x + f(x)) = -x + f(x + f(x)). -/
        have:=b (-hz) (hz+u ↑(hz))
        /- Substituting step “ii.” into step “iv.”, we have
            f(f(x)) = x + f(-x) + f(x) or f(x + f(-x) + f(x)) = f(x). -/
        simp_all[ add_assoc, C]
        induction this
        · -- Step "vi.": First, consider the case where f(f(x)) = x + f(-x) + f(x).
          /- Step "vi.1" In this case, step “iii.” simplifies to
              f(-x) + f(x) = f(a) + f(-a)
              or f(x + f(a) + f(-a)) = f(x). In the first case we are done,
              so we focus only on the second case. -/
          simp_all
          /- Step "vi.2": We have
              f(x + f(x + f(a) + f(-a))) = f(x) + x + (f(a) + f(-a)) or
              f(f(x) + x + f(a) + f(-a)) = x + f(x + f(a) + f(-a)). -/
          have:=b hz (hz+(u a+u (-a)))
          /- Step "vi.3": We have
              f(x + f(a) + f(-a) + f(x + f(a) + f(-a)))
              = x + f(a) + f(-a) + f(x + f(a) + f(-a)). -/
          have:=b (hz+(u a+u (-a)))$ hz+(u a+u (-a))
          /- Step "vi.4": Substituting step “vi.1.” into step “vi.2” gives
              f(x +f(x))=f(x)+x+(f(a)+f(-a)) or f(f(x)+x+f(a)+f(-a))=x+f(x).
              Step "vi.5" Substituting step “vi.1.” into step “vi.3.” gives
              f(x+f(a)+f(-a)+f(x))=x+f(a)+f(-a)+f(x).
              Substituting step “vi.5.” into step “vi.4.” and simplifying gives
              f(x +f(x))=f(x)+x+(f(a)+f(-a)) or f(a)+f(-a)=0.
              The former case simplifies via step “ii.” to f(a)+f(-a)=0,
              so in both cases we have a contradiction. -/
          use .inr$ by_contra$ by hint
        -- Step "vii." Now, consider the case where f(x + f(-x) + f(x)) = f(x).
        /- Step "vii.1": We have f(x + f(x + f(-x) + f(x))) = f(x) + x + f(-x) + f(x)
            or f(f(x) + x + f(-x) + f(x)) = x + f(x + f(-x) + f(x)). -/
        have:=b hz$ hz+(u hz+u (-hz))
        /- Step "vii.2": We have f(f(x + f(-x) + f(x)) + x + f(-x) + f(x)) =
            x + f(-x) + f(x) + f(x + f(-x) + f(x)).
            Step "vii.3": Substituting step “vii.” into step “vii.2.” gives
            f(f(x)+x+f(-x)+f(x))= x+f(-x)+f(x)+f(x).
            Substituting step “vii.” into step “1.” gives
            f(x+f(x))=f(x)+x+f(-x)+f(x) or
            f(f(x)+x+f(-x)+f(x))=x+f(x).
            In the first case we can substitute in step “ii.” and
            simplify to f(-x)+f(x)=0 as desired.
            In the second case we can substitute in step “vii.3” to
            obtain f(-x)+f(x)=0 again as desired. -/
        cases b (hz+(u hz+u (-hz)))$ hz+(u hz+u (-hz))with|_=>hint
      -- Step "g.": Now, consider the case where  f(f(x) + a) = x + f(a).
      /- Step "i.": We have f(-x + f(f(x) + a)) = f(-x) + (f(x) + a) or
          f(f(-x) + f(x) + a) = -x + f(f(x) + a). -/
      have:=b (-hz) (u hz+a)
      have:=b$ -a
      /- Step "ii." We have f(-a + f(f(x) + a)) = f(-a) + (f(x) + a) or
          f(f(-a) + (f(x) + a)) = -a + f(f(x) + a). -/
      specialize this (u hz+a)
      /- Step "iii.": Substituting step “g.” into step “i.” gives
          f(f(a)) = f(-x) + (f(x) + a) or f(f(-x) + f(x) + a) = f(a).
  .      Step "iv.": Substituting step “g.” into step “ii.” gives
          f(-a + x + f(a)) = f(-a) + f(x) + a or
          f(f(-a) + f(x) + a) = -a + x + f(a). -/
      simp_all[ ←add_assoc]
      have:=b 0
      have:=b
      -- Step "v.": We have f(a + f(a)) = a + f(a).
      specialize b a a
      simp_all[add_comm]
      /- Step "vi.": We have f(-a + f(a + f(a))) = f(-a) + a + f(a) or
          f(f(-a) + a + f(a)) = -a + f(a + f(a)). -/
      have:=(this<| -a) (↑a + (((u a))): (↑_ :((( _) ) ) )) ..
      /- Step "vii.": Substituting step “v.” into step “vi.” and simplifying gives
          f(f(a)) = a + f(a) + f(-a) or f(a + f(a) + f(-a)) = f(a). -/
      simp_all[add_assoc]
      cases this
      · -- Step "viii.": First, consider the case where f(f(a)) = a + f(a) + f(-a).
        /- Step "viii.1": In this case, step “iii.” simplifies to
            f(a) + f(-a) = f(-x) + f(x) or f(f(-x) + f(x) + a) = f(a).
            In the first case we are done, so we focus only on the second case. -/
        simp_all
        contrapose! IsAquaesulian_def
        simp_all
        exfalso
        /- Step "viii.2": We have
            f(a + f(a + (f(x) + f(-x)))) = a + (f(x) + f(-x)) + f(a) or
            f(a + (f(x) + f(-x)) + f(a)) = a + f(a + (f(x) + f(-x))). -/
        have:=this a (a+(u hz+u ( -hz)))
        simp_all[Ne.symm,Bool]
        /- Step "viii.3": We have
            f(a + f(x) + f(-x) + f(a + f(x) + f(-x))) =
            a + f(x) + f(-x) + f(a + f(x) + f(-x)). -/
        have:=‹∀congr_arg G,_› (a+(u hz+u (-hz)))$ a+(u ↑hz+u ↑( -hz) )
        /- Step "viii.4": Substituting step “viii.1” into step “viii.3” gives
            f(a + f(x) + f(-x) + f(a))=a + f(x) + f(-x) + f(a).
            The result follows by casework on step “viii.2”; In the first case,
            substituting in step “viii.1” followed by step “v.” gives
            f(x) + f(-x) = 0 as desired, and in the second case,
            substituting in step “viiii.4” followed by step “viii.1” gives
            f(x) + f(-x) = 0 again as desired.
        -/
        simp_all
      -- Step "ix.": Now, consider the case where f(a + f(a) + f(-a)) = f(a).
      /- Step "ix.1.": We have f(a + f(a + f(a) + f(-a))) = f(a) + a + f(a) + f(-a)
          or f(f(a) + a + f(a) + f(-a)) = a + f(a + f(a) + f(-a)). -/
      have:=this a (a +(u a+u (-a)))
      /- Step "ix.2.": We have
          f(a + f(a) + f(-a) + f(a + f(a) + f(-a)))
          = a + f(a) + f(-a) + f(a + f(a) + f(-a)).
          Step "ix.3.": Substituting step “ix.” into step “ix.2” gives
          f(a + f(a) + f(-a) +f(a)) = a + f(a) + f(-a) + f(a).
          The result follows by casework on step “ix.1.”: In the first case,
          we can substitute in step “ix.” followed by step “v.” to get f(a)+f(-a)=0,
          and in the second case we can substitute in step “ix.3.”
          followed by step “ix.” to get f(a)+f(-a)=0 again.
          Either way, this contradicts our assumption about a. -/
      cases‹forall Jd S,_› (a+(u a+u (-a))) ( a + (u a +u ↑(-a)))with| _ =>hint
    /- Now let f be an aquaesulian function with f(0) ≠ 0.
        We will derive a contradiction. -/
    simp_all
    /- We have:
        P(0, 0) -> f(f(0)) = f(0),
        P(f(0), f(0)) -> f(f(0) + f(f(0))) = f(0) + f(f(0)) ->
        f(2f(0)) = 2f(0),
        P(0, f(0)) -> f(f(f(0))) = 2f(0) or f(2f(0)) = f(f(0)) ->
        f(0) = 2f(0) or f(2f(0)) = f(0) -> f(0) = 2f(0) or 2f(0) = f(0),
        so f(0) = 0 as desired. -/
    cases b 0 0with|_=>exact absurd (b 0$ (0+(1 *(@(u ↑.((0) )))))^ 01: ↑ ((_)) ) (id$ (by(cases ( b (u 0) ( (u 0)))with|_ => continuity)))
  rintro K V
  -- Now let f(x) = -x + 2⌈x⌉. We claim that f is aquaesulian.
  specialize V $ λ N=>-N+2 *Int.ceil N
  specialize( V $ (IsAquaesulian_def _).mpr _)
  · simp_rw [ ←eq_sub_iff_add_eq']
    /- The functional equation simplifies to
        ⌈x - y + ⌈y⌉ * 2⌉ * 2 = ⌈y⌉ * 2 + ⌈x⌉ * 2 or
        ⌈-x + y + ⌈x⌉ * 2⌉ * 2 = ⌈y⌉ * 2 + ⌈x⌉ * 2. -/
    ring
    use mod_cast@?_
    /- Which is equivalent to:
        (A) ⌈y⌉ + ⌈x⌉ - 1 < x - y + ⌈y⌉ * 2 ≤ ⌈y⌉ + ⌈x⌉ or
        (B) ⌈y⌉ + ⌈x⌉ - 1 < -x + y + ⌈x⌉ * 2 ≤ ⌈y⌉ + ⌈x⌉ -/
    norm_num[<-add_mul,Int.ceil_eq_iff]
    useλc K=>(em _).imp (⟨by linarith[Int.ceil_lt_add_one c,Int.le_ceil K],.⟩) (by repeat use by linarith[.,Int.le_ceil c,or,Int.ceil_lt_add_one$ K])
    /- If x - y + ⌈y⌉ * 2 ≤ ⌈y⌉ + ⌈x⌉ then we have the desired result (A)
        since ⌈y⌉ < y + 1.
        Otherwise, we have ⌈y⌉ + ⌈x⌉ < x - y + ⌈y⌉ * 2 which we negate and
        add ⌈x⌉ * 2 + ⌈y⌉ * 2 to get -x + y + ⌈x⌉ * 2 < ⌈y⌉ + ⌈x⌉,
        from which we get the desired result (B) since ⌈x⌉ < x + 1. -/
  simp_all[Int.ceil_neg, ←add_assoc]
  suffices:2<=V.1.toFinset.card
  · let M:=V.1.toFinset
    norm_num[this,V.2.trans',(Set.ext$ by simp_all[M]: {x :Rat|∃t:Rat, (↑2 ) * ( ⌈ t ⌉:(ℚ ) ) .. + (- (2 *⌊(t)⌋)) = ↑x} = M)]
  /- Finally, we have f(-1) + f(1) = 0 and f(1/2) = f(-1/2) = 2
      as two distinct values of f. Thus, c = 2 is tight as desired. -/
  use Finset.one_lt_card.2$ by exists@0,V.1.mem_toFinset.2 (by exists-1),2,V.1.mem_toFinset.2 (by exists 1/2)

#print axioms imo_2024_p6
