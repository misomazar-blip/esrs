from supabase import create_client
from dotenv import load_dotenv
import os

load_dotenv()

supabase = create_client(
    os.getenv('NEXT_PUBLIC_SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

print("Activating EFRAG-IG3-2024 version...")

# Deactivate all versions first
print("1. Deactivating all versions...")
supabase.table('esrs_version').update({'is_active': False}).neq('id', '00000000-0000-0000-0000-000000000000').execute()

# Activate EFRAG-IG3-2024
print("2. Activating EFRAG-IG3-2024...")
result = supabase.table('esrs_version').update({'is_active': True}).eq('version_code', 'EFRAG-IG3-2024').execute()

if result.data:
    print(f"✓ Activated EFRAG-IG3-2024 version")
    print(f"  ID: {result.data[0]['id']}")
    print(f"  Name: {result.data[0]['version_name']}")
else:
    print("✗ Failed to activate version")

# Show current active version
print("\n3. Current active version:")
active = supabase.table('esrs_version').select('*').eq('is_active', True).execute()
if active.data:
    for v in active.data:
        print(f"  • {v['version_code']} - {v['version_name']}")
else:
    print("  No active version found")

print("\n✓ Done!")
