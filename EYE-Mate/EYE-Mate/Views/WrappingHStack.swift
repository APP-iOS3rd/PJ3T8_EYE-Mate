//
//  WrappingHStack.swift
//  EYE-Mate
//
//  Created by seongjun on 2/13/24.
//

import SwiftUI

/// 수평적으로 배치된 요소들을 화면에 표시하되, 너비를 초과하는 경우 자동으로 줄 바꿈하여 요소들을 적절하게 배치
struct WrappingHStack: Layout {
    private var horizontalSpacing: CGFloat
    private var verticalSpacing: CGFloat
    /// 요소들 사이의 수평 및 수직 간격을 결정. 기본적으로 수직 간격은 수평 간격과 동일하게 설정되지만, 수직 간격을 별도로 지정할 수도 있음.
    public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat? = nil) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing ?? horizontalSpacing
    }
    
    /// 제안된 뷰 크기(proposal)와 하위 뷰(subviews)를 기반으로 WrappingHStack의 크기를 계산. 먼저 각 하위 뷰의 높이를 구하고, 그 중 최대 높이를 찾음. 그런 다음 각 행의 너비를 계산하고, 최대 행 너비와 행의 수를 고려하여 총 크기를 결정.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        /// 하위 뷰(subviews)가 비어 있는지 확인. 비어 있다면 크기를 CGSize.zero로 반환.
        guard !subviews.isEmpty else { return .zero }
        /// 각 하위 뷰의 높이를 가져와 최대 높이를 찾음. 이것은 각 행의 높이가 됨.
        let height = subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0
        /// 각 행의 너비를 저장할 배열
        var rowWidths = [CGFloat]()
        /// 현재 행의 너비를 나타내는 변수
        var currentRowWidth: CGFloat = 0
        subviews.forEach { subview in
            /// 현재 행의 너비와 새로운 하위 뷰의 너비 및 수평 간격을 합산하여 proposal의 너비와 비교. 만약 너비가 초과된다면 새로운 행이 필요하므로 rowWidths에 현재 행의 너비를 추가하고 현재 행의 너비를 새로운 하위 뷰의 너비로 설정.
            if currentRowWidth + horizontalSpacing + subview.sizeThatFits(proposal).width >= proposal.width ?? 0 {
                rowWidths.append(currentRowWidth)
                currentRowWidth = subview.sizeThatFits(proposal).width
            } 
            /// 그렇지 않으면, 현재 행에 하위 뷰를 추가. 현재 행의 너비에 하위 뷰의 너비와 수평 간격을 추가.
            else {
                currentRowWidth += horizontalSpacing + subview.sizeThatFits(proposal).width
            }
        }
        /// 마지막 행의 너비를 rowWidths에 추가.
        rowWidths.append(currentRowWidth)
        /// 행의 수
        let rowCount = CGFloat(rowWidths.count)
        /// 계산된 행의 최대 너비 및 높이를 기반으로 최종 CGSize를 반환. 행의 수에 따라 높이가 결정되며, 각 행 사이의 간격은 verticalSpacing에 의해 결정.
        return CGSize(width: max(rowWidths.max() ?? 0, proposal.width ?? 0), height: rowCount * height + (rowCount - 1) * verticalSpacing)
    }

    /// WrappingHStack의 하위 뷰를 실제 화면에 배치. 각 하위 뷰를 적절한 위치에 배치하고, 너비를 초과하는 경우 다음 행으로 넘어가도록 함.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        /// 하위 뷰가 없다면 함수를 종료
        guard !subviews.isEmpty else { return }
        /// 각 하위 뷰의 높이를 가져와 최대 높이를 찾음. 이것은 각 행의 높이가 됨.
        let height = subviews.map { $0.dimensions(in: proposal).height }.max() ?? 0
        /// WrappingHStack의 좌측 가장자리 좌표로 초기화
        var x = bounds.minX
        /// 첫 번째 행의 중간 좌표로 초기화
        var y = height / 2 + bounds.minY
        subviews.forEach { subview in
            /// 현재 하위 뷰의 너비의 반만큼 x 좌표를 이동
            x += subview.dimensions(in: proposal).width / 2
            /// 만약 현재 하위 뷰를 추가했을 때 화면 우측 경계를 넘어간다면 다음 행으로 넘어감
            if x + subview.dimensions(in: proposal).width / 2 > bounds.maxX {
                /// x 좌표를 WrappingHStack의 좌측 가장자리에 설정
                x = bounds.minX + subview.dimensions(in: proposal).width / 2
                /// y 좌표를 다음 행으로 이동. 행의 높이와 수직 간격을 고려.
                y += height + verticalSpacing
            }
            /// 하위 뷰를 해당 위치에 배치. 이때, 각 하위 뷰의 크기 및 위치를 place 메서드를 통해 설정.
            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .center,
                proposal: ProposedViewSize(
                    width: subview.dimensions(in: proposal).width,
                    height: subview.dimensions(in: proposal).height
                )
            )
            /// 현재 하위 뷰를 배치한 후, x 좌표를 현재 하위 뷰의 우측 경계와 다음 하위 뷰 사이의 수평 간격만큼 이동.
            x += subview.dimensions(in: proposal).width / 2 + horizontalSpacing
        }
    }
}

#Preview {
    WrappingHStack(horizontalSpacing: 5) {
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
        Text("Hello")
    }
}
