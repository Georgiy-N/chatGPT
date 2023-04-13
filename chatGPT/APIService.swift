import Foundation

class APIService {
    let baseURL = "https://api.openai.com/v1"
    let apiKey = "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" // Ваш API ключ OpenAI

    func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "\(baseURL)/completions"
        let parameters: [String: Any] = [
            "prompt": prompt,
            "model": "davinci",
            "temperature": 0.5, // настройки модели
            "max_tokens": 100
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "com.example.network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let choices = json?["choices"] as? [[String: Any]]
                    let text = choices?.first?["text"] as? String
                    completion(.success(text ?? ""))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
