"use client";

import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from "recharts";
import { colors, fonts } from "@/lib/styles";

type ProgressData = {
  name: string;
  value: number;
  color: string;
};

export default function ProgressCircle({
  answered,
  total,
  size = 120,
  showLabel = true,
}: {
  answered: number;
  total: number;
  size?: number;
  showLabel?: boolean;
}) {
  const percentage = total > 0 ? Math.round((answered / total) * 100) : 0;

  const data: ProgressData[] = [
    { name: "Answered", value: answered, color: colors.primary },
    { name: "Remaining", value: total - answered, color: colors.borderGray },
  ];

  return (
    <div style={{ position: "relative", width: size, height: size }}>
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius={size * 0.3}
            outerRadius={size * 0.45}
            dataKey="value"
            startAngle={90}
            endAngle={-270}
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} />
            ))}
          </Pie>
          <Tooltip />
        </PieChart>
      </ResponsiveContainer>
      {showLabel && (
        <div
          style={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            textAlign: "center",
          }}
        >
          <div
            style={{
              fontSize: size * 0.18,
              fontWeight: 700,
              color: colors.textPrimary,
            }}
          >
            {percentage}%
          </div>
          <div
            style={{
              fontSize: size * 0.1,
              color: colors.textSecondary,
              marginTop: "2px",
            }}
          >
            {answered}/{total}
          </div>
        </div>
      )}
    </div>
  );
}
