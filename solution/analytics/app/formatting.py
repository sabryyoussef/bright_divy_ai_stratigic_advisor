"""CEO-facing copy derived only from deterministic JSON (no LLM math)."""

import re


def format_financial_bleed_en(payload: dict) -> str:
    """English narrative for chat layer; digits come from payload only."""
    period = payload["period"]
    net = float(payload["net_qar"])
    bleed = bool(payload["bleed_detected"])
    net_s = f"{net:,.2f}"
    if bleed:
        return (
            f"Net for {period} is **{net_s} QAR** (negative). "
            f"Financial bleed is **detected** (summary: {payload['summary_key']})."
        )
    return (
        f"Net for {period} is **{net_s} QAR** (positive). "
        f"No bleed detected (summary: {payload['summary_key']})."
    )


def format_financial_bleed_ar(payload: dict) -> str:
    """Arabic narrative for chat layer; digits come from payload only."""
    period = payload["period"]
    net = float(payload["net_qar"])
    bleed = bool(payload["bleed_detected"])
    net_s = f"{net:,.2f}"
    if bleed:
        return (
            f"صافي شهر {period} هو **{net_s} ر.ق** (سالب). "
            f"يُرصد **نزيف مالي** (ملخص: {payload['summary_key']})."
        )
    return (
        f"صافي شهر {period} هو **{net_s} ر.ق** (موجب). "
        f"لا يُرصد نزيف مالي (ملخص: {payload['summary_key']})."
    )


def extract_numeric_tokens(text: str) -> list[str]:
    """Pull digit groups from formatted text for bilingual consistency checks."""
    return re.findall(r"-?\d[\d,]*(?:\.\d+)?", text)
