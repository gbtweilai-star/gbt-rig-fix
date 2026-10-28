# rig_fix

**One capability bit from GBT V8, packaged standalone.** No. 53 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 绑骨修复（Blender 4.2 · 本地 · 零付费）：**自动定轴**（三轴跨度取最大为身高轴，不再假设 Y-up/Z-up）· 补权重 · 归一化 · 去杂物（可选）· 转台照 · **六条硬判据**（单网格+蒙皮 / 无 42 顶点杂物球 / 量具自证换算 0.3~3 / 身高 1.720±0.02 在**文件空间**量 / 未绑顶点归零 / 蒙皮网格被骨架带动）。⚠️ 它**不重做动作修正**（出件后必须再跑 anim_fix，否则腿折在胯上、手举过头顶 —— 2026-10-19 实栽）。op=status/plan（纯读）· run（写 outputs/rig-fix/ ⇒ 要票）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-rig-fix.git
cd gbt-rig-fix
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_rig_fix info                  # capability card
python -m gbt_rig_fix spec --json           # machine-readable contract
python -m gbt_rig_fix check --payload '{}'
python -m gbt_rig_fix run   --payload '{}'
```

Real `info` output from this machine:

```text
rig_fix  (creation)  v1.0.0
----------------------------------------
绑骨修复（Blender 4.2 · 本地 · 零付费）：**自动定轴**（三轴跨度取最大为身高轴，不再假设 Y-up/Z-up）· 补权重 · 归一化 · 去杂物（可选）· 转台照 · **六条硬判据**（单网格+蒙皮 / 无 42 顶点杂物球 / 量具自证换算 0.3~3 / 身高 1.720±0.02 在**文件空间**量 / 未绑顶点归零 / 蒙皮网格被骨架带动）。⚠️ 它**不重做动作修正**（出件后必须再跑 anim_fix，否则腿折在胯上、手举过头顶 —— 2026-10-19 实栽）。op=status/plan（纯读）· run（写 outputs/rig-fix/ ⇒ 要票）

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_rig_fix import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `rig_fix` |
| domain | `creation` |
| handler | `dh_rig` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/rig_fix](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/rig_fix.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
