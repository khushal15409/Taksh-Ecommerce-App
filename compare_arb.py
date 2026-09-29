import json

def load_keys(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    # Filter out keys starting with @ (metadata) and @@ (locale info)
    return set(k for k in data.keys() if not k.startswith('@'))

en_keys = load_keys(r'c:\Users\Sunil.Kumar\Downloads\taksh_e_commerce-feature-arpit-prev-apk-ui\taksh_e_commerce-feature-arpit-prev-apk-ui\lib\l10n\app_en.arb')
hi_keys = load_keys(r'c:\Users\Sunil.Kumar\Downloads\taksh_e_commerce-feature-arpit-prev-apk-ui\taksh_e_commerce-feature-arpit-prev-apk-ui\lib\l10n\app_hi.arb')

missing_in_hi = en_keys - hi_keys
missing_in_en = hi_keys - en_keys

print(f"Total EN keys (excluding metadata): {len(en_keys)}")
print(f"Total HI keys (excluding metadata): {len(hi_keys)}")

if missing_in_hi:
    print("\nMissing keys in HI:")
    for k in sorted(missing_in_hi):
        print(f"- {k}")

if missing_in_en:
    print("\nKeys in HI but not in EN:")
    for k in sorted(missing_in_en):
        print(f"- {k}")

if not missing_in_hi and not missing_in_en:
    print("\nAll functional keys are present in both files.")
