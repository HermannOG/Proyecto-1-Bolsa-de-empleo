package progra4.prestamos.security;


import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import progra4.prestamos.model.*;
import progra4.prestamos.repository.*;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final EmpresaRepository empresaRepo;
    private final OferenteRepository oferenteRepo;
    private final AdministradorRepository adminRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        // EMPRESA
        var empresa = empresaRepo.findByCorreo(username);
        if (empresa.isPresent()) {
            Empresa e = empresa.get();

            if (!e.getAprobada())
                throw new UsernameNotFoundException("Empresa no aprobada");

            return new UserDetailsImpl(
                    e.getCorreo(),
                    e.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_EMPRESA"))
            );
        }

        // OFERENTE
        var oferente = oferenteRepo.findByCorreo(username);
        if (oferente.isPresent()) {
            Oferente o = oferente.get();

            if (!o.getAprobado())
                throw new UsernameNotFoundException("Oferente no aprobado");

            return new UserDetailsImpl(
                    o.getCorreo(),
                    o.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_OFERENTE"))
            );
        }

        // ADMIN
        var admin = adminRepo.findByIdentificacion(username);
        if (admin.isPresent()) {
            Administrador a = admin.get();

            return new UserDetailsImpl(
                    a.getIdentificacion(),
                    a.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_ADMIN"))
            );
        }

        throw new UsernameNotFoundException("Usuario no encontrado");
    }
}
