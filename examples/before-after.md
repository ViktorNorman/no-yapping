# Before / After

Real coding turns, yappy version vs `no-yapping`. Same correctness, less noise.

---

## 1. Small change

**User:** make this function return early if `items` is empty

**❌ Before**

> Great question! Adding an early return here is a really clean way to handle the
> edge case and improve readability. It's generally considered a best practice to
> guard against empty inputs at the top of a function. Here's how I'd refactor it
> in order to make it more robust:
>
> ```js
> function total(items) {
>   if (items.length === 0) return 0
>   return items.reduce((a, b) => a + b.price, 0)
> }
> ```
>
> Let me know if you'd like me to add type checking as well!

**✅ After**

> ```diff
>   function total(items) {
> +   if (items.length === 0) return 0
>     return items.reduce((a, b) => a + b.price, 0)
>   }
> ```

---

## 2. A real choice

**User:** how do I dedupe this array of user objects by id?

**❌ Before**

> There are several approaches to deduplicating arrays of objects, each with its
> own trade-offs around performance and readability. The most idiomatic modern
> approach leverages a Map, which is generally more performant for larger datasets
> because it avoids the O(n²) behavior you'd get from a naive filter/findIndex
> approach. Let me walk you through both...

**✅ After**

> ```js
> // A — Map, O(n):
> const unique = [...new Map(users.map(u => [u.id, u])).values()]
>
> // B — filter, O(n²), reads simpler:
> const unique = users.filter((u, i) => users.findIndex(x => x.id === u.id) === i)
> ```

---

## 3. Blocked by ambiguity

**User:** add caching to this endpoint

**❌ Before**

> Caching is a broad topic and the right strategy really depends on your specific
> requirements around freshness, invalidation, and infrastructure. Are you thinking
> in-memory? Redis? HTTP cache headers? There are trade-offs to each. Generally
> speaking, it's worth considering...

**✅ After**

> One thing changes the code: cache where?
>
> 1. In-memory (single instance) — I'd default to this for simplicity.
> 2. Redis (shared across instances).
>
> Say 1 or 2 and I'll write it.

---

## 4. Ripcord pulled

**User:** why is B slower? explain

**✅ After** (rule 8 — explain fully when asked)

> `findIndex` scans the array for every element, so it's O(n²): 10k users → ~100M
> comparisons. The Map builds a lookup once and reads in O(1), so the whole pass is
> O(n). At small n the difference is invisible; it bites past a few thousand items.

The mode steps aside the moment you ask for reasoning. That's the point — the *why*
is available on demand, not forced on every turn.
