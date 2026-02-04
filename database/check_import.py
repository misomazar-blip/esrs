from supabase import create_client
from dotenv import load_dotenv
import os

load_dotenv()

supabase = create_client(
    os.getenv('NEXT_PUBLIC_SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

# Get all topics
topics = supabase.table('topic').select('code,name,id').execute()

print("="*70)
print("EFRAG IG3 IMPORT STATUS")
print("="*70)

version_id = 'd3c509a5-3f23-41b4-b902-e171c136c645'
total = 0

for t in topics.data:
    count = supabase.table('disclosure_question')\
        .select('id', count='exact')\
        .eq('topic_id', t['id'])\
        .eq('version_id', version_id)\
        .execute()
    
    if count.count > 0:
        print(f"{t['code']:4s}: {count.count:3d} datapoints")
        total += count.count

print("="*70)
print(f"TOTAL: {total} datapoints imported")
print("="*70)
