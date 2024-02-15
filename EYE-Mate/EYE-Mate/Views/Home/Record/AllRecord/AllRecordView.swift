//
//  AllRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordView: View {
    let recordType: TestType

    @State var isDeleteMode = false

    var body: some View {
        VStack {
            AllRecordHeader(isDeleteMode: $isDeleteMode, recordType: recordType, onPressDeleteButton: { isDeleteMode.toggle() })
            AllRecordList(isDeleteMode: $isDeleteMode, recordType: recordType)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AllRecordView(recordType: TestType.eyesight)
}
