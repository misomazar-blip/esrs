-- ESRS SME Questions for E1-E5 and S1-S4 modules
-- Based on EFRAG Draft Simplified ESRS (November 2025)

-- Get topic IDs
DO $$
DECLARE
  topic_e1_id uuid;
  topic_e2_id uuid;
  topic_e3_id uuid;
  topic_e4_id uuid;
  topic_e5_id uuid;
  topic_s1_id uuid;
  topic_s2_id uuid;
  topic_s3_id uuid;
  topic_s4_id uuid;
BEGIN
  -- Get topic IDs
  SELECT id INTO topic_e1_id FROM topic WHERE code = 'E1';
  SELECT id INTO topic_e2_id FROM topic WHERE code = 'E2';
  SELECT id INTO topic_e3_id FROM topic WHERE code = 'E3';
  SELECT id INTO topic_e4_id FROM topic WHERE code = 'E4';
  SELECT id INTO topic_e5_id FROM topic WHERE code = 'E5';
  SELECT id INTO topic_s1_id FROM topic WHERE code = 'S1';
  SELECT id INTO topic_s2_id FROM topic WHERE code = 'S2';
  SELECT id INTO topic_s3_id FROM topic WHERE code = 'S3';
  SELECT id INTO topic_s4_id FROM topic WHERE code = 'S4';

  -- E1: Climate Change
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_e1_id, 'E1-DR1', 'Describe your transition plan for climate change mitigation', 'Include targets, actions, and resources allocated for reducing greenhouse gas emissions', 'textarea', 1),
  (topic_e1_id, 'E1-DR2', 'Report your Scope 1 and Scope 2 greenhouse gas emissions', 'Provide total GHG emissions in tonnes of CO2 equivalent. Scope 1: direct emissions. Scope 2: indirect emissions from purchased energy', 'textarea', 2),
  (topic_e1_id, 'E1-DR3', 'Report your Scope 3 greenhouse gas emissions (if material)', 'Include significant indirect emissions from your value chain (e.g., purchased goods, business travel, waste)', 'textarea', 3),
  (topic_e1_id, 'E1-DR4', 'Describe your energy consumption and mix', 'Report total energy consumption and breakdown by renewable vs non-renewable sources', 'textarea', 4),
  (topic_e1_id, 'E1-DR5', 'Describe climate-related risks and opportunities', 'Identify physical risks (e.g., extreme weather) and transition risks (e.g., policy changes) affecting your business', 'textarea', 5);

  -- E2: Pollution
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_e2_id, 'E2-DR1', 'Describe your policies and actions to prevent pollution', 'Include measures to reduce emissions to air, water, and soil', 'textarea', 1),
  (topic_e2_id, 'E2-DR2', 'Report emissions of pollutants', 'Include air pollutants (NOx, SOx, particulate matter) and water pollutants if material', 'textarea', 2),
  (topic_e2_id, 'E2-DR3', 'Describe substances of concern and very high concern', 'List any use or production of hazardous substances and phase-out plans', 'textarea', 3),
  (topic_e2_id, 'E2-DR4', 'Describe pollution incidents and remediation', 'Report any pollution incidents and corrective actions taken', 'textarea', 4);

  -- E3: Water and Marine Resources
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_e3_id, 'E3-DR1', 'Describe your water and marine resources management', 'Include policies and actions for water consumption, discharge, and marine resource protection', 'textarea', 1),
  (topic_e3_id, 'E3-DR2', 'Report water consumption and withdrawal', 'Provide total water consumption in cubic meters, by source (surface water, groundwater, etc.)', 'textarea', 2),
  (topic_e3_id, 'E3-DR3', 'Report water discharge', 'Include volume and quality of water discharge, by destination and treatment level', 'textarea', 3),
  (topic_e3_id, 'E3-DR4', 'Describe water-related risks', 'Identify water stress in operations and value chain', 'textarea', 4);

  -- E4: Biodiversity and Ecosystems
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_e4_id, 'E4-DR1', 'Describe your policies and actions on biodiversity', 'Include measures to avoid, minimize, restore, and offset impacts on biodiversity', 'textarea', 1),
  (topic_e4_id, 'E4-DR2', 'Describe sites in or near biodiversity-sensitive areas', 'Identify operations located in or near protected areas or areas of high biodiversity value', 'textarea', 2),
  (topic_e4_id, 'E4-DR3', 'Describe impacts on species and habitats', 'Report material impacts on threatened species and ecosystems', 'textarea', 3),
  (topic_e4_id, 'E4-DR4', 'Describe dependencies on ecosystem services', 'Identify how your business relies on natural resources and ecosystem services', 'textarea', 4);

  -- E5: Resource Use and Circular Economy
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_e5_id, 'E5-DR1', 'Describe your policies and actions on resource use', 'Include circular economy strategies, waste reduction, and sustainable sourcing', 'textarea', 1),
  (topic_e5_id, 'E5-DR2', 'Report resource inflows', 'Provide data on materials used (total weight), including renewable and non-renewable materials', 'textarea', 2),
  (topic_e5_id, 'E5-DR3', 'Report resource outflows (waste)', 'Include total waste generated by type and disposal method (recycled, incinerated, landfilled)', 'textarea', 3),
  (topic_e5_id, 'E5-DR4', 'Describe circular design and product lifetime', 'Explain how products are designed for durability, reuse, repair, and recycling', 'textarea', 4);

  -- S1: Own Workforce
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_s1_id, 'S1-DR1', 'Describe your policies on working conditions', 'Include health and safety, working time, fair wages, and work-life balance', 'textarea', 1),
  (topic_s1_id, 'S1-DR2', 'Report workforce composition', 'Provide headcount by gender, employment type (permanent/temporary), and age group', 'textarea', 2),
  (topic_s1_id, 'S1-DR3', 'Report collective bargaining coverage', 'Percentage of employees covered by collective agreements', 'textarea', 3),
  (topic_s1_id, 'S1-DR4', 'Report work-related incidents', 'Include number and rate of accidents, injuries, and fatalities', 'textarea', 4),
  (topic_s1_id, 'S1-DR5', 'Describe training and development', 'Report average hours of training per employee and skills development programs', 'textarea', 5),
  (topic_s1_id, 'S1-DR6', 'Report diversity metrics', 'Include gender diversity in management and pay gap data if material', 'textarea', 6);

  -- S2: Workers in the Value Chain
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_s2_id, 'S2-DR1', 'Describe your policies on value chain workers', 'Include due diligence on working conditions, forced labor, and child labor in supply chain', 'textarea', 1),
  (topic_s2_id, 'S2-DR2', 'Describe engagement with suppliers', 'Explain how you assess and monitor social risks in your supply chain', 'textarea', 2),
  (topic_s2_id, 'S2-DR3', 'Report material negative impacts identified', 'Describe any human rights violations or poor working conditions found and remediation actions', 'textarea', 3),
  (topic_s2_id, 'S2-DR4', 'Describe grievance mechanisms', 'Explain how value chain workers can raise concerns and how complaints are handled', 'textarea', 4);

  -- S3: Affected Communities
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_s3_id, 'S3-DR1', 'Describe your policies on community engagement', 'Include consultation processes and respect for indigenous peoples rights', 'textarea', 1),
  (topic_s3_id, 'S3-DR2', 'Describe material impacts on communities', 'Identify positive and negative impacts on local communities (economic, social, environmental)', 'textarea', 2),
  (topic_s3_id, 'S3-DR3', 'Describe engagement with affected communities', 'Explain how you consult with and involve communities in decision-making', 'textarea', 3),
  (topic_s3_id, 'S3-DR4', 'Report grievance mechanisms for communities', 'Describe how communities can raise concerns and complaint resolution process', 'textarea', 4);

  -- S4: Consumers and End-users
  INSERT INTO disclosure_question (topic_id, code, question_text, help_text, answer_type, order_index) VALUES
  (topic_s4_id, 'S4-DR1', 'Describe your policies on consumer protection', 'Include product safety, data privacy, fair marketing, and accessibility', 'textarea', 1),
  (topic_s4_id, 'S4-DR2', 'Describe product and service safety', 'Explain quality control, safety testing, and incident response procedures', 'textarea', 2),
  (topic_s4_id, 'S4-DR3', 'Report consumer complaints and resolution', 'Number of complaints received and resolution rate', 'textarea', 3),
  (topic_s4_id, 'S4-DR4', 'Describe data privacy and security', 'Explain measures to protect consumer data and compliance with privacy regulations', 'textarea', 4);

END $$;
