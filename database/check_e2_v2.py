from supabase import create_client
from dotenv import load_dotenv
import os

load_dotenv()
supabase = create_client(
    os.getenv('NEXT_PUBLIC_SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

version_id = 'd3c509a5-3f23-41b4-b902-e171c136c645'

# Check all datapoints with like E2%
result = supabase.table('disclosure_question')\
    .select('datapoint_id,question_text,code')\
    .eq('version_id', version_id)\
    .ilike('datapoint_id', 'E2%')\
    .order('datapoint_id')\
    .execute()

print(f"Found {len(result.data)} E2 datapoints")
for d in result.data[:10]:
    print(f"  {d['datapoint_id']:20s} | code: {d.get('code', 'N/A'):20s} | {d['question_text'][:60]}")
