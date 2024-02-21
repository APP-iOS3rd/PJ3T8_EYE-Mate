//
//  EmptyVisionChart.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import Charts
import SwiftUI

struct VisionData: Identifiable {
    let id = UUID()
    let date: String
    let left: Double
    let right: Double
}

struct EmptyVisionChart: View {
    let dataArray = [
        VisionData(date: "23.12.30", left: 0, right: 0.1),
    ]

    var body: some View {
        let visionData = calculateVisionData()

        return createChart(with: visionData)
            .frame(height: 120)
            .padding(.vertical, 20)
    }

    private func calculateVisionData() -> [(side: String, data: [VisionRecordData])] {
        let visionData: [(side: String, data: [VisionRecordData])] = [
            (
                side: "left",
                data: dataArray.map { VisionRecordData(publishedDate: $0.date, point: $0.left) }
            ),
            (
                side: "right",
                data: dataArray.map { VisionRecordData(publishedDate: $0.date, point: $0.right) }
            )
        ]
        return visionData
    }

    private func createChart(with data: [(side: String, data: [VisionRecordData])]) -> some View {
        return EmptyChartView(data: data)
    }
}

struct EmptyChartView: View {
    let data: [(side: String, data: [VisionRecordData])]

    var body: some View {
        // Chart 뷰 생성 및 설정
        Chart(data, id: \.side) { data in
            ForEach(data.data, id: \.publishedDate) { recordData in
                BarMark(x: .value("date", recordData.publishedDate), y: .value("point", recordData.point))
            }
            .foregroundStyle(by: .value("Side", data.side))
            .position(by: .value("Side", data.side))
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: [0, 0.5, 1.0, 1.5]) { value in
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
            AxisMarks(values: .automatic) { }
        }
        .chartForegroundStyleScale([
            "left" : Color(hex: "#586BCF").opacity(0),
            "right" : Color(hex: "#FFB647").opacity(0),
        ])
        .chartLegend(.hidden)
    }
}


#Preview {
    EmptyVisionChart()
}
