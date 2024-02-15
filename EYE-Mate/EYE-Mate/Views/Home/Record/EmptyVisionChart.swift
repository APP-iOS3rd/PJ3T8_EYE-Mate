//
//  EmptyVisionChart.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import Charts
import SwiftUI

struct EmptyVisionChart: View {
    let dataArray = [
        VisionData(date: "23.12.30(토)", left: 0, right: 0.1),
    ]

    private func removeDay(dateString: String) -> String {
        if let regex = try? NSRegularExpression(pattern: "\\(.*?\\)"), let match = regex.firstMatch(in: dateString, range: NSRange(dateString.startIndex..., in: dateString)) {

            return (dateString as NSString).replacingCharacters(in: match.range, with: "")
        } else {
            return dateString
        }
    }

    var body: some View {
        let visionData = [
            (
                side: "left",
                data: dataArray.map { VisionChartData(date: removeDay(dateString: $0.date), point: $0.left) }
            ),
            (
                side: "right",
                data: dataArray.map { VisionChartData(date: removeDay(dateString: $0.date), point: $0.right) }
            )
        ]

        Chart(visionData, id: \.side) { data in
            ForEach(data.data, id: \.date) {
                BarMark(x: .value("date", $0.date), y: .value("point", $0.point))
            }
            .foregroundStyle(by: .value("Side", data.side))
            .position(by: .value("Side", data.side))
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: [1.5, 1.0, 0.5, 0]) { value in
                if let point = value.as(Double.self) {
                    if point == 0 {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 3)).foregroundStyle(Color.tabGray)
                    } else {
                        AxisGridLine().foregroundStyle(Color.tabGray)
                    }
                }
                AxisValueLabel() {
                    if let point = value.as(Double.self) {
                        Text("\(String(format: "%.1f", point))")
                            .font(.pretendardRegular_12)
                            .foregroundStyle(Color.tabGray)

                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) {
            }
        }
        .chartForegroundStyleScale([
            "left" : Color(hex: "#586BCF").opacity(0),
            "right" : Color(hex: "#FFB647").opacity(0),
        ])
        .chartLegend(.hidden)
        .frame(height: 120)
        .padding(.vertical, 20)
    }
}

#Preview {
    EmptyVisionChart()
}
