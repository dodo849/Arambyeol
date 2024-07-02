//
//  MenuService.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Alamofire
import Factory

final class MenuService {
    @Injected(\.menuConverter) private var menuConverter
    
    func fetchMenu() async throws -> MenuModel {
        let url = URLConfig.restMenu.baseURL + "/menu"

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .get
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: MenuDTO.Response.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let response):
                    let conveted = self.menuConverter
                        .convertToMenuModel(from: response)
                    continuation.resume(returning: conveted)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
