//
//  VisionChart.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import Charts
import SwiftUI

struct VisionRecordData {
    let publishedDate: String
    let point: Double
}


struct VisionChart: View {
    let visionRecords: [VisionRecord]

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy.MM.dd HH:mm:ss"

        return formatter
    }()

    private func calculateVisionData() -> [(side: String, data: [VisionRecordData])] {
        let visionData: [(side: String, data: [VisionRecordData])] = [
            (
                side: "left",
                data: visionRecords.map { VisionRecordData(publishedDate: VisionChart.dateFormat.string(from: $0.publishedDate), point: Double($0.left)!) }
            ),
            (
                side: "right",
                data: visionRecords.map { VisionRecordData(publishedDate: VisionChart.dateFormat.string(from: $0.publishedDate), point: Double($0.right)!) }
            )
        ]

        return visionData
    }

    var body: some View {
        let visionData = calculateVisionData()

        return createChart(with: visionData)
            .frame(height: 120)
            .padding(.vertical, 20)
    }

    private func createChart(with data: [(side: String, data: [VisionRecordData])]) -> some View {
        return ChartView(data: data)
    }
}

struct ChartView: View {
    let data: [(side: String, data: [VisionRecordData])]

    private func removeTime(dateString: String) -> String {
        let pattern = "\\d{2}\\.\\d{2}\\.\\d{2}"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        guard let match = regex?.firstMatch(in: dateString, options: [], range: NSRange(location: 0, length: dateString.utf16.count)) else {
            return dateString
        }
        if let range = Range(match.range, in: dateString) {
            return String(dateString[range])
        }
        return dateString
    }

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
            AxisMarks(values: .automatic) { value in
                AxisValueLabel() {
                    if let date = value.as(String.self) {
                        Text(removeTime(dateString: date))
                            .font(.pretendardRegular_12)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .chartForegroundStyleScale([
            "left" : Color(hex: "#586BCF"),
            "right" : Color(hex: "#FFB647"),
        ])
        .chartLegend(.hidden)
    }
}
