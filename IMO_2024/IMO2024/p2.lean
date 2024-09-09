import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.Continuity
import Mathlib.Tactic.Have

open scoped Nat

/--
Determine all pairs $(a, b)$ of positive integers for which there exist positive integers $g$ and $N$ such that
$$
\operatorname{gcd}(a^n + b, b^n + a) = g
$$
holds for all integers $n \ge N$.
(Note that $\operatorname{gcd}(x, y)$ denotes the greatest common divisor of integers $x$ and $y$.)

Solution: $a = 1$ and $b = 1$
-/
theorem imo_2024_p2 : {(a, b) | 0 < a ∧ 0 < b ∧ ∃ g N, 0 < g ∧ 0 < N ∧ ∀ n ≥ N, Nat.gcd (a ^ n + b) (b ^ n + a) = g} = {(1, 1)} := by
  induction(10)+2
  · use Set.eq_singleton_iff_unique_mem.2 ⟨?_,λb g=>by_contra$ g.2.2.rec λY S i=>S.rec λL D=>?_⟩
    · -- (1, 1) satisfies the condition with g = 2, N = 3.
      exact⟨by left,by left,2,3,by simp_all⟩
    -- We claim that this is the only solution.
    -- The agent wastes the next 16 lines proving then discarding a lemma.
    have:b.1+b.2∣Y:=?_
    · suffices: b.1= b.2
      · norm_num[b.ext_iff,<-D.2.2 L,this]at*
        use(pow_lt_pow (g.1.nat_succ_le.lt_of_ne' i) (by left)).ne' (D.2.2 _ L.le_succ)
      suffices:b.1+b.2∣b.fst^ (2 *L) +b.2 ∧(b).fst +(b).snd ∣ b.snd^ (2 *L)+b.1
      · suffices:b.1^2%(b.1+b.2)=b.2^2%(b.1+b.snd)
        · norm_num[Nat.add_mod,pow_mul,this,Nat.dvd_iff_mod_eq_zero,Nat.pow_mod]at*
          norm_num[add_comm,b.ext_iff,sq _,←Nat.pow_mod,←Nat.dvd_iff_mod_eq_zero]at*
          zify at*
          cases this.1.sub this.2with|_ Z=> nlinarith [ (by (nlinarith): Z=0 )]
        apply@Nat.modEq_of_dvd
        use(b.snd)-b.fst , (by·ring: ( (b.snd) : ℤ)^2-b.fst^2=(b.fst+(b).2) * _)
      norm_num[(2).le_mul_of_pos_left,Nat.gcd_dvd,← D.2.2 (2 *L), this.trans, (D.right.1 :_)]
    suffices:b.1+b.2∣b.1^(2*L)+b.2 ∧b.1+b.2 ∣b.snd^ (2 *L) +b.1
    · exact D.2.2 (2 *(L )) (le_mul_of_one_le_left' (by decide ) )▸dvd_gcd (this.left) (this).2
    exfalso
    -- First, assume ab + 1 | g.
    suffices:b.1*b.2+1∣Y
    · suffices:b.1^φ (b.1*b.2+1)%(b.1*b.2+1)=1%(b.1*b.2+1) ∧b.2^ φ (b.1* b.snd+1)%((b).1 * ↑(b.snd)+1)= 1% (b.1*b.snd + 1)
      · /- Then ab + 1 | a ^ (Nφ(ab + 1)) + b and
          ab + 1 | b ^ (Nφ(ab + 1)) + a. -/
        absurd D.2.2 (φ (b.1*b.2+1)*L) (by nlinarith [((b.fst *b.2+1).totient_pos).2 ↑ Fin.size_pos'])
        apply mt (.▸Nat.gcd_dvd _ _)
        useλH=>absurd (‹_∣Y›.trans H.1) (λv=>absurd (‹_∣Y›.trans H.2) ? _)
        norm_num[pow_mul,b.ext_iff,(1).mod_eq_of_lt,g.symm,this,Nat.add_mod,Nat.dvd_iff_mod_eq_zero,Nat.pow_mod]at(i)v⊢
        /- By Euler's Theorem, a ^ (Nφ(ab + 1)) ≡ 1 (mod ab + 1),
          so ab + 1 | b + 1 and ab + 1 | a + 1. -/
        norm_num[add_comm,pow_mul,<-Nat.dvd_iff_mod_eq_zero]at*
        contrapose! i
        zify at*
        /- Thus ab + 1 ≤ b + 1 and ab + 1 ≤ a + 1 which requires
          a = b = 1 as desired. -/
        repeat use by nlinarith[Int.le_of_dvd (by linarith) v,Int.le_of_dvd (by linarith) i]
      repeat use↑(Nat.ModEq.pow_totient (by norm_num))
    -- Now, we proceed to show that indeed ab + 1 | g.
    by_contra! H
    suffices:b.1^φ (b.1*b.2+1)%(b.1*b.2+1)=1%(b.1*b.2+1) ∧b.2^φ (b.1*b.2+1)%(b.1*b.2+1)=1%( b.fst * ↑ (b.snd)+1)
    · simp_all
      /- It suffices to show that
        ab + 1 | a^(φ(ab + 1)(N + 1) - 1) + b and
        ab + 1 | b^(φ(ab + 1)(N + 1) - 1) + a. -/
      suffices:b.1*b.2+1∣b.1^(φ (b.1*b.2+1)*(L+1)-1)+b.2 ∧b.1*b.2+1∣b.2^(φ (b.1* b.2+1)* (L+1)-1)+(b.fst)
      · use H$ D.2.2 (φ _ *(L+1)-1) (L.le_sub_of_add_le (by nlinarith[((b.1* b.2+1).totient_pos).2 Nat.succ_pos']))▸(((Nat.dvd_gcd) ( this).1)) this.right
      cases B:Nat.exists_eq_add_of_lt$ ((b.1*b.2+1).totient_pos).2 (by continuity)
      norm_num[*, g, ‹φ _ = _›, mul_add,Nat.pow_mod,(1).mod_eq_of_lt,pow_add,Nat.add_mod,pow_mul,Nat.dvd_iff_mod_eq_zero,Nat.mul_mod] at this⊢
      simp_all
      /- Since a, b are coprime to ab + 1, it suffices to show that
        ab + 1 | a(a^(φ(ab + 1)(N + 1) - 1) + b) and
        ab + 1 | b(b^(φ(ab + 1)(N + 1) - 1) + a). -/
      suffices:b.1*b.2+1∣b.1*( (b.1%((b).1 * ( b.snd) + 1) : _)^‹Nat› +b.snd) ∧(b.fst * ↑(b.snd) + 1)∣(b).snd*( (b.snd%((b).fst * b.snd + 1))^ ‹Nat›+b.fst)
      · norm_num[<-Nat.dvd_iff_mod_eq_zero,g,(1).mod_eq_of_lt,Nat.dvd_mul] at this⊢
        exists@?_
        · cases this.1 with|_ Q r=>simp_all[(Q.dvd_gcd r.1 ⟨_,.symm r.right.choose_spec.2⟩).antisymm]
        cases@this.2with|_ F X=>simp_all[(F.dvd_gcd X.1 ⟨_,symm X.2.choose_spec.2⟩).antisymm]
      /- This follows from Euler's Theorem:
        a(a^(φ(ab + 1)(N + 1) - 1) + b)
        ≡ a^(φ(ab + 1)(N + 1)) + ab
        ≡ 1 + ab
        ≡ 0 (mod ab + 1)
        and similarly for b(b^(φ(ab + 1)(N + 1) - 1) + a). -/
      simp_all[mul_comm, mul_add,add_comm,Nat.add_mod,Nat.dvd_iff_mod_eq_zero]
    repeat use(Nat.ModEq.pow_totient (by . . .norm_num) )
  congr 26

#print axioms imo_2024_p2
