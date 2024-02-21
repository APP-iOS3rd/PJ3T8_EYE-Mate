//
//  RecordViewModel.swift
//  EYE-Mate
//
//  Created by seongjun on 2/20/24.
//

import FirebaseFirestore

struct VisionRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var left: String
    var right: String
    var publishedDate: Date
}

struct ColorVisionRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var status: String
    var publishedDate: Date
}

struct AstigmatismRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var left: String
    var right: String
    var publishedDate: Date
}

struct EyesightRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var left: String
    var right: String
    var publishedDate: Date
}

final class RecordViewModel: ObservableObject {
    static let shared = RecordViewModel()

    @Published var isPresentedVisionRecordListView = false
    @Published var isPresentedColorVisionRecordListView = false
    @Published var isPresentedAstigmatismRecordListView = false
    @Published var isPresentedEyesightRecordListView = false

    @Published private(set) var visionRecords: [VisionRecord] = []
    @Published private(set) var recentVisionRecords: [VisionRecord] = []

    @Published private(set) var colorVisionRecords: [ColorVisionRecord] = []
    @Published private(set) var recentColorVisionRecords: [ColorVisionRecord] = []

    @Published private(set) var astigmatismRecords: [AstigmatismRecord] = []
    @Published private(set) var recentAstigmatismRecords: [AstigmatismRecord] = []

    @Published private(set) var eyesightRecords: [EyesightRecord] = []
    @Published private(set) var recentEyesightRecords: [EyesightRecord] = []

    let db = Firestore.firestore()

    @MainActor
    func fetchVisionRecord() async throws {
        let snapshot = try await db.collection("Records").document("JVGqkutgyQPwq0Cebwtpun5pPeq1").collection("Visions").getDocuments()
        var visions: [VisionRecord] = []

        for document in snapshot.documents {
            let vision = try document.data(as: VisionRecord.self)
            visions.append(vision)
        }

        visions.sort(by: { $0.publishedDate > $1.publishedDate })
        let recentVisions = Array(visions.prefix(5))

        await MainActor.run {
            self.visionRecords = visions
            self.recentVisionRecords = recentVisions
        }
    }

    @MainActor
    func fetchColorVisionRecord() async throws {
        let snapshot = try await db.collection("Records").document("JVGqkutgyQPwq0Cebwtpun5pPeq1").collection("Colors").getDocuments()
        var colorVisions: [ColorVisionRecord] = []

        for document in snapshot.documents {
            let colorVision = try document.data(as: ColorVisionRecord.self)
            colorVisions.append(colorVision)
        }

        colorVisions.sort(by: { $0.publishedDate > $1.publishedDate })
        let recentColorVisions = Array(colorVisions.prefix(5))

        await MainActor.run {
            self.colorVisionRecords = colorVisions
            self.recentColorVisionRecords = recentColorVisions
        }
    }

    @MainActor
    func fetchAstigmatismRecord() async throws {
        let snapshot = try await db.collection("Records").document("JVGqkutgyQPwq0Cebwtpun5pPeq1").collection("Astigmtisms").getDocuments()
        var astigmatisms: [AstigmatismRecord] = []

        for document in snapshot.documents {
            let astigmatism = try document.data(as: AstigmatismRecord.self)
            astigmatisms.append(astigmatism)
        }

        astigmatisms.sort(by: { $0.publishedDate > $1.publishedDate })
        let recentAstigmatisms = Array(astigmatisms.prefix(5))

        await MainActor.run {
            self.astigmatismRecords = astigmatisms
            self.recentAstigmatismRecords = recentAstigmatisms
        }
    }

    @MainActor
    func fetchEyesightRecord() async throws {
        let snapshot = try await db.collection("Records").document("JVGqkutgyQPwq0Cebwtpun5pPeq1").collection("Sights").getDocuments()
        var eysights: [EyesightRecord] = []

        for document in snapshot.documents {
            let eyesight = try document.data(as: EyesightRecord.self)
            eysights.append(eyesight)
        }

        eysights.sort(by: { $0.publishedDate > $1.publishedDate })
        let recentEyesights = Array(eysights.prefix(5))

        await MainActor.run {
            self.eyesightRecords = eysights
            self.recentEyesightRecords = recentEyesights
        }
    }

}
