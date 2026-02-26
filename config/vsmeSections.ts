// VSME Section Metadata
// Human-friendly titles based on EFRAG documentation

export interface SectionMeta {
  group: string;
  title: string;
}

export const VSME_SECTION_META: Record<string, SectionMeta> = {
  // General information (Basic module)
  B1: {
    group: "General Information",
    title: "Basis for preparation"
  },
  B2: {
    group: "General Information",
    title: "Practices, policies & future initiatives"
  },
  
  // Environment (Basic module)
  B3: {
    group: "Environment",
    title: "Energy & greenhouse gas emissions"
  },
  B4: {
    group: "Environment",
    title: "Pollution (air, water, soil)"
  },
  B5: {
    group: "Environment",
    title: "Biodiversity"
  },
  B6: {
    group: "Environment",
    title: "Water"
  },
  B7: {
    group: "Environment",
    title: "Resource use, circular economy & waste"
  },
  
  // Environment (Basic module)
  B8: {
    group: "Environment",
    title: "Workforce – General characteristics"
  },
  B9: {
    group: "Environment",
    title: "Workforce – Health & safety"
  },
  B10: {
    group: "Environment",
    title: "Workforce – Pay, collective bargaining & training"
  },
  
  // Environment (Basic module)
  B11: {
    group: "Environment",
    title: "Corruption & bribery (convictions & fines)"
  },
  
  // General Information (Comprehensive module)
  C1: {
    group: "General Information",
    title: "Strategy: business model & sustainability initiatives"
  },
  C2: {
    group: "Social",
    title: "Practices, policies & future initiatives (expanded)"
  },
  
  // Social (Comprehensive module)
  C3: {
    group: "Social",
    title: "GHG targets & climate transition"
  },
  C4: {
    group: "Social",
    title: "Climate risks"
  },
  
  // Social (Comprehensive module)
  C5: {
    group: "Social",
    title: "Additional workforce characteristics"
  },
  C6: {
    group: "Social",
    title: "Human rights policies & processes"
  },
  C7: {
    group: "Social",
    title: "Severe human rights incidents"
  },
  
  // Governance (Comprehensive module)
  C8: {
    group: "Social",
    title: "Revenues & EU benchmark exclusions"
  },
  C9: {
    group: "Social",
    title: "Gender diversity in governance body"
  }
};

// Group display order for UI rendering
export const GROUP_ORDER = [
  "General Information",
  "Environment",
  "Social",
  "Governance",
  "Additional disclosures",
  "Other"
];
