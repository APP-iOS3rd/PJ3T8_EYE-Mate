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

    var dictionary: [String: Any] {
        return [
            "left": left,
            "right": right,
            "publishedDate": publishedDate,
        ]
    }
}

struct ColorVisionRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var status: String
    var publishedDate: Date

    var dictionary: [String: Any] {
        return [
            "status": status,
            "publishedDate": publishedDate,
        ]
    }
}

struct AstigmatismRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var left: String
    var right: String
    var publishedDate: Date

    var dictionary: [String: Any] {
        return [
            "left": left,
            "right": right,
            "publishedDate": publishedDate,
        ]
    }
}

struct EyesightRecord: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var left: String
    var right: String
    var publishedDate: Date

    var dictionary: [String: Any] {
        return [
            "left": left,
            "right": right,
            "publishedDate": publishedDate,
        ]
    }
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
    func fetchVisionRecord(uid: String) async throws {
        let snapshot = try await db.collection("Records").document(uid).collection("Visions").getDocuments()
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

    func deleteVisionRecord(uid: String, record: VisionRecord) {
        db.collection("Records").document(uid).collection("Visions").document(record.id!).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }

        let index = visionRecords.firstIndex { currentRecord in
            return currentRecord.id == record.id
        } ?? 0
        visionRecords.remove(at: index)

        let recentVisions = Array(visionRecords.prefix(5))
        recentVisionRecords = recentVisions
    }

    func createVisionRecord(uid: String, visionRecord: VisionRecord) {
        let _ = db.collection("Records").document(uid).collection("Visions").document().setData(visionRecord.dictionary) { error in
            if let error = error {
                print("Error create document: \(error.localizedDescription)")
            } else {
                print("Document successfully created!")
            }
        }
    }

    @MainActor
    func fetchColorVisionRecord(uid: String) async throws {
        let snapshot = try await db.collection("Records").document(uid).collection("Colors").getDocuments()
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

    func deleteColorVisionRecord(uid: String, record: ColorVisionRecord) {
        db.collection("Records").document(uid).collection("Colors").document(record.id!).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }

        let index = colorVisionRecords.firstIndex { currentRecord in
            return currentRecord.id == record.id
        } ?? 0
        colorVisionRecords.remove(at: index)

        let recentColorVisions = Array(colorVisionRecords.prefix(5))
        recentColorVisionRecords = recentColorVisions
    }

    func createColorVisionRecord(uid: String, colorVisionRecord: ColorVisionRecord) {
        let _ = db.collection("Records").document(uid).collection("Colors").document().setData(colorVisionRecord.dictionary)
    }

    @MainActor
    func fetchAstigmatismRecord(uid: String) async throws {
        let snapshot = try await db.collection("Records").document(uid).collection("Astigmatisms").getDocuments()
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

    func deleteAstigmatismVisionRecord(uid: String, record: AstigmatismRecord) {
        db.collection("Records").document(uid).collection("Astigmatisms").document(record.id!).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }

        let index = astigmatismRecords.firstIndex { currentRecord in
            return currentRecord.id == record.id
        } ?? 0
        astigmatismRecords.remove(at: index)

        let recentAstigmatisms = Array(astigmatismRecords.prefix(5))
        recentAstigmatismRecords = recentAstigmatisms
    }

    func createAstigmatismRecord(uid: String, astigmatismRecord: AstigmatismRecord) {
        let _ = db.collection("Records").document(uid).collection("Astigmatisms").document().setData(astigmatismRecord.dictionary)
    }

    @MainActor
    func fetchEyesightRecord(uid: String) async throws {
        let snapshot = try await db.collection("Records").document(uid).collection("Sights").getDocuments()
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

    func deleteEyesightVisionRecord(uid: String, record: EyesightRecord) {
        db.collection("Records").document(uid).collection("Sights").document(record.id!).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }

        let index = eyesightRecords.firstIndex { currentRecord in
            return currentRecord.id == record.id
        } ?? 0
        eyesightRecords.remove(at: index)

        let recentEyesights = Array(eyesightRecords.prefix(5))
        recentEyesightRecords = recentEyesights
    }

    func createEyesightRecord(uid: String, eyesightRecord: EyesightRecord) {
        let _ = db.collection("Records").document(uid).collection("Sights").document().setData(eyesightRecord.dictionary)
    }
}
