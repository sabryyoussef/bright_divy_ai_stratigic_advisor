from app.formatting import (
    extract_numeric_tokens,
    format_financial_bleed_ar,
    format_financial_bleed_en,
)


def test_bilingual_numeric_tokens_match_sample_payload() -> None:
    payload = {
        "period": "2026-01",
        "revenue_qar": 50000.0,
        "expense_qar": 65500.0,
        "net_qar": -15500.0,
        "bleed_detected": True,
        "summary_key": "NEGATIVE_NET",
        "drivers": [],
    }
    en = format_financial_bleed_en(payload)
    ar = format_financial_bleed_ar(payload)
    net_s = f"{float(payload['net_qar']):,.2f}"
    assert net_s in en and net_s in ar
    assert extract_numeric_tokens(en) == extract_numeric_tokens(ar)
    assert "2026-01" in en and "2026-01" in ar
