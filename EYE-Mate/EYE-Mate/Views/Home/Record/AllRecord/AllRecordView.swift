//
//  AllRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordView: View {
    let recordType: TestType

    var body: some View {
        VStack {
            AllRecordHeader(recordType: recordType, onPressDeleteButton: {})
            AllRecordList(recordType: recordType)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AllRecordView(recordType: TestType.eyesight)
}
